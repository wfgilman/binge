defmodule ApiWeb.DishActionController do
  use ApiWeb, :controller

  def create(conn, %{"action" => "like"} = params) do
    _ = Core.Dish.like(params["user_id"], params["dish_id"], params["restaurant_id"])
    send_resp(conn, 204, "")
  end

  def create(conn, %{"action" => "unlike"} = params) do
    _ = Core.Dish.unlike(params["user_id"], params["dish_id"])
    send_resp(conn, 204, "")
  end
end
