defmodule ApiWeb.LikeController do
  use ApiWeb, :controller

  def index(conn, %{"active_friend" => "true"}) do
    user = Guardian.Plug.current_resource(conn)
    data = Core.Like.get_friend_likes(user)

    conn
    |> put_status(200)
    |> put_view(ApiWeb.LikeView)
    |> render("index.json", data: data)
  end
end
