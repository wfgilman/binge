defmodule ApiWeb.LikeView do
  use ApiWeb, :view

  def render("index.json", %{data: likes}) do
    Enum.map(likes, fn like ->
      %{
        dish_id: like.dish_id,
        restaurant_id: like.restaurant_id
      }
    end)
  end
end
