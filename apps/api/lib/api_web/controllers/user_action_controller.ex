defmodule ApiWeb.UserActionController do
  use ApiWeb, :controller

  def create(conn, %{"user_id" => user_id, "type" => "sms"}) do
    user = Core.User.generate_verification_code(user_id)
    sms = %Notify.SMS{type: "sms_code", args: [user, user.verify_code]}

    case Notification.send(sms) do
      {:ok, _} ->
        send_resp(conn, 204, "")

      {:error, message, _} ->
        conn
        |> put_status(400)
        |> put_view(ApiWeb.ErrorView)
        |> render("twilio.json", message: message)
    end
  end

  def update(conn, %{"user_id" => user_id, "code" => code}) do
    with user when not is_nil(user) <- Db.Repo.get(Db.Model.User, user_id),
         true <- Core.User.verify_user(user, code) do
      conn
      |> put_status(201)
      |> put_view(ApiWeb.TokenView)
      |> render("show.json", data: generate_access_token(conn, user))
    else
      nil ->
        conn
        |> put_status(404)
        |> put_view(ApiWeb.ErrorView)
        |> render("404.json", message: "We couldn't find that user.")

      false ->
        conn
        |> put_status(400)
        |> put_view(ApiWeb.ErrorView)
        |> render("invalid_code.json")
    end
  end

  defp generate_access_token(conn, user) do
    conn
    |> Api.Guardian.Plug.sign_in(user, %{typ: "access"})
    |> Api.Guardian.Plug.current_token()
  end
end
