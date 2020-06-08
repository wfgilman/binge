defmodule ApiWeb.AuthErrorHandler do
  use ApiWeb, :controller
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, reason}, _opts) do
    conn
    |> put_status(401)
    |> put_view(ApiWeb.ErrorView)
    |> render("token.json", message: reason)
    |> halt()
  end
end
