from terraso_allauth.views import TerrasoOAuth2Adapter


def test_adapter_loads_url_from_settings(settings):
    url = "https://testing.terraso.org/"
    settings.TERRASO_BASE_API_URL = url

    assert TerrasoOAuth2Adapter(None).terraso_base_url == url


def test_adapter_apppend_slash_to_base_url(settings):
    url = "https://testing.terraso.org"
    settings.TERRASO_BASE_API_URL = url

    assert TerrasoOAuth2Adapter(None).terraso_base_url == url + "/"


def test_adapter_default_base_url():
    assert TerrasoOAuth2Adapter(None).terraso_base_url == "https://api.terraso.org/"


def test_adapter_builds_access_token_url():
    adapter = TerrasoOAuth2Adapter(None)

    assert f"{adapter.terraso_base_url}oauth/token/" in adapter.access_token_url


def test_adapter_builds_authorize_url():
    adapter = TerrasoOAuth2Adapter(None)

    assert f"{adapter.terraso_base_url}auth/authorize" == adapter.authorize_url


def test_adapter_builds_profile_url():
    adapter = TerrasoOAuth2Adapter(None)

    assert f"{adapter.terraso_base_url}oauth/userinfo" == adapter.profile_url
