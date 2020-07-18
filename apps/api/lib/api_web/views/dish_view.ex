defmodule ApiWeb.DishView do
  use ApiWeb, :view

  def render("index.json", %{data: dishes}) do
    Enum.map(dishes, fn dish ->
      %{
        id: dish.id,
        name: dish.name,
        type: dish.type,
        category: dish.category,
        tags: dish.tags,
        image_url: dish.image_url,
        match: dish.match,
        restaurant_id: dish.restaurant.id,
        restaurant_name: dish.restaurant.name,
        restaurant_match: dish.restaurant.match,
        doordash_url: dish.restaurant.doordash_url,
        website_url: dish.restaurant.website,
        phone: dish.restaurant.phone,
        ubereats_url: nil
      }
    end)
  end
end
