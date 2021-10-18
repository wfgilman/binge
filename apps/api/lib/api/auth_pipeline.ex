defmodule Api.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :api,
    module: Api.Guardian,
    error_handler: ApiWeb.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, claims: %{typ: "access"}, scheme: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, ensure: true
end
