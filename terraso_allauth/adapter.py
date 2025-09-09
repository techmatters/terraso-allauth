from allauth.socialaccount.providers.oauth2.views import OAuth2Adapter
from .provider import TerrasoProvider


class TerrasoOAuth2Adapter(OAuth2Adapter):
    provider_id = TerrasoProvider.id

    # Dummy endpoints — won't be called in tests
    authorize_url = "https://example.com/oauth/authorize"
    access_token_url = "https://example.com/oauth/token"
    profile_url = "https://example.com/oauth/userinfo"

    def complete_login(self, request, app, token, **kwargs):
        # Return fake user data for tests
        extra_data = {
            "id": "fake-terraso-user-id",
            "email": "user@example.com",
            "name": "Test User",
        }
        return self.get_provider().sociallogin_from_response(request, extra_data)
