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

  def create(conn, %{"action" => "match"} = params) do
    user =
      Guardian.Plug.current_resource(conn)
      |> Db.Repo.preload(:friend)

    with friend when not is_nil(friend) <- user.friend,
         true <- friend.friend_id == user.id,
         true <- not is_nil(friend.device_token),
         true <- friend.push_enabled do
      push = %Notify.Push{type: "match", args: [user, friend, params["restaurant"] || false]}
      Notification.send(push)
    end

    send_resp(conn, 204, "")
  end
end
