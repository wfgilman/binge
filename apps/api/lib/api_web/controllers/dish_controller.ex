defmodule ApiWeb.DishController do
  use ApiWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(200)
    |> put_view(ApiWeb.DishView)
    |> render("index.json", data: Core.Dish.list())
  end

  def list(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    data =
      case params["filter"] do
        nil ->
          Core.Dish.list(user)

        "likes" ->
          Core.Dish.get_likes(user)

        "matches" ->
          Core.Dish.get_matches(user)
      end

    conn
    |> put_status(200)
    |> put_view(ApiWeb.DishView)
    |> render("index.json", data: data)
  end
end
