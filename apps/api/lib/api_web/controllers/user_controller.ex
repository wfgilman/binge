defmodule ApiWeb.UserController do
  use ApiWeb, :controller

  def invite(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, friend} <- Core.User.create(params),
         {:ok, _} <- Core.Match.create(user, friend),
         {:ok, _} <- Core.User.update(user, %{friend_id: friend.id}) do
      send_resp(conn, 204, "")
    else
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(ApiWeb.ErrorView)
        |> render("changeset.json", data: changeset)
    end
  end

  def index(conn, %{"active" => "true"}) do
    user = Guardian.Plug.current_resource(conn)
    friend = Core.Match.get(user)

    conn
    |> put_status(200)
    |> put_view(ApiWeb.UserView)
    |> render("show.json", data: friend)
  end

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    friends = Core.Match.list(user)

    conn
    |> put_status(200)
    |> put_view(ApiWeb.UserView)
    |> render("index.json", data: friends)
  end

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> put_status(200)
    |> put_view(ApiWeb.UserView)
    |> render("show.json", data: user)
  end

  def create(conn, params) do
    case Core.User.create(params) do
      {:ok, user} ->
        conn
        |> put_status(201)
        |> put_view(ApiWeb.UserView)
        |> render("show.json", data: user)

      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(ApiWeb.ErrorView)
        |> render("changeset.json", data: changeset)
    end
  end

  def update(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    case Core.User.update(user, params) do
      {:ok, _} ->
        send_resp(conn, 204, "")

      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(ApiWeb.ErrorView)
        |> render("changeset.json", data: changeset)
    end
  end

  def delete(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    Db.Repo.delete!(user)
    send_resp(conn, 204, "")
  end
end
