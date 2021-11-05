defmodule ApiWeb.LikeView do
  use ApiWeb, :view

  def render("index.json", %{data: likes}) do
    %{
      count: Enum.count(likes),
      data: Enum.map(likes, &dish_json/1)
    }
  end

  defp dish_json(like) do
    %{
      dish_id: like.dish_id,
      restaurant_id: like.restaurant_id
    }
  end
end
