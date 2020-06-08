defmodule ApiWeb.UserController do
  use ApiWeb, :controller

  def create(conn, params) do
    case Core.User.create(params) do
      {:ok, user} ->
        conn
        |> put_status(201)
        |> put_view(ApiWeb.UserView)
        |> render("show.json", data: Db.Repo.preload(user, :match_user))

      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(ApiWeb.ErrorView)
        |> render("changeset.json", data: changeset)
    end
  end
end
