import requests
from allauth.socialaccount.helpers import complete_social_login, render_authentication_error
from allauth.socialaccount.models import SocialLogin
from allauth.socialaccount.providers.base import ProviderException
from allauth.socialaccount.providers.base.constants import AuthError
from allauth.socialaccount.providers.oauth2.client import OAuth2Error
from allauth.socialaccount.providers.oauth2.views import OAuth2Adapter, OAuth2LoginView, OAuth2View
from allauth.utils import get_request_param
from django.conf import settings
from django.core.exceptions import PermissionDenied
from requests import RequestException

from .provider import TerrasoProvider


class TerrasoOAuth2Adapter(OAuth2Adapter):
    provider_id = TerrasoProvider.id

    @property
    def terraso_base_url(self):
        if hasattr(settings, "TERRASO_BASE_API_URL") and settings.TERRASO_BASE_API_URL:
            terraso_base_url = settings.TERRASO_BASE_API_URL
        else:
            terraso_base_url = "https://api.terraso.org/"

        return terraso_base_url if terraso_base_url[-1] == "/" else f"{terraso_base_url}/"

    @property
    def access_token_url(self):
        return f"{self.terraso_base_url}oauth/token/"

    @property
    def authorize_url(self):
        return f"{self.terraso_base_url}auth/authorize"

    @property
    def profile_url(self):
        return f"{self.terraso_base_url}oauth/userinfo"

    def complete_login(self, request, app, token, **kwargs):
        resp = requests.get(
            self.profile_url,
            params={"access_token": token.token},
        )
        resp.raise_for_status()
        extra_data = resp.json()
        login = self.get_provider().sociallogin_from_response(request, extra_data)
        return login


oauth2_login = OAuth2LoginView.adapter_view(TerrasoOAuth2Adapter)


class OAuth2CallbackView(OAuth2View):
    def dispatch(self, request, *args, **kwargs):
        if "error" in request.GET or "code" not in request.GET:
            auth_error = request.GET.get("error", None)

            if auth_error == self.adapter.login_cancelled_error:
                error = AuthError.CANCELLED
            else:
                error = AuthError.UNKNOWN

            return render_authentication_error(request, self.adapter.provider_id, error=error)

        app = self.adapter.get_provider().get_app(self.request)
        client = self.get_client(self.request, app)

        try:
            access_token = self.adapter.get_access_token_data(request, app, client)
            token = self.adapter.parse_token(access_token)
            token.app = app
            login = self.adapter.complete_login(request, app, token, response=access_token)
            login.token = token

            if self.adapter.supports_state:
                login.state = SocialLogin.verify_and_unstash_state(
                    request, get_request_param(request, "state")
                )
            else:
                login.state = SocialLogin.unstash_state(request)

            return complete_social_login(request, login)
        except (
            PermissionDenied,
            OAuth2Error,
            RequestException,
            ProviderException,
        ) as e:
            return render_authentication_error(request, self.adapter.provider_id, exception=e)


oauth2_callback = OAuth2CallbackView.adapter_view(TerrasoOAuth2Adapter)
