defmodule ApiWeb.DishActionController do
  use ApiWeb, :controller

  def create(conn, %{"action" => "like"} = params) do
    user = Guardian.Plug.current_resource(conn)
    _ = Core.Dish.like(user.id, params["dish_id"], params["restaurant_id"])
    send_resp(conn, 204, "")
  end

  def create(conn, %{"action" => "unlike"} = params) do
    user = Guardian.Plug.current_resource(conn)
    _ = Core.Dish.unlike(user.id, params["dish_id"])
    send_resp(conn, 204, "")
  end
end
