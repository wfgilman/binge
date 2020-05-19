defmodule ApiWeb.DishController do
  use ApiWeb, :controller

  def index(conn, params) do
    conn
    |> put_status(200)
    |> put_view(ApiWeb.DishView)
    |> render("index.json", data: Db.Repo.all(Db.Model.Dish) |> Db.Repo.preload(:restaurant))
  end
end
