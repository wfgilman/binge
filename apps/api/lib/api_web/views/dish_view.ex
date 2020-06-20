defmodule ApiWeb.DishView do
  use ApiWeb, :view

  def render("index.json", %{data: dishes}) do
    Enum.map(dishes, fn dish ->
      %{
        id: dish.id,
        name: dish.name,
        type: dish.type,
        image_url: dish.image_url,
        match: dish.match,
        restaurant_id: dish.restaurant.id,
        restaurant_name: dish.restaurant.name,
        doordash_url: dish.restaurant.doordash_url
      }
    end)
  end
end
