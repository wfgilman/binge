defmodule ApiWeb.DishController do
  use ApiWeb, :controller

  def index(conn, %{"filter" => "likes"}) do
    data = Core.Dish.get_likes("bg")

    conn
    |> put_status(200)
    |> put_view(ApiWeb.DishView)
    |> render("index.json", data: data)
  end

  def index(conn, _params) do
    data =
      Db.Model.Dish
      |> Db.Repo.all()
      |> Db.Repo.preload(:restaurant)
      |> Enum.shuffle()

    conn
    |> put_status(200)
    |> put_view(ApiWeb.DishView)
    |> render("index.json", data: data)
  end
end
