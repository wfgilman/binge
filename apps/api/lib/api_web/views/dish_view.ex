defmodule ApiWeb.DishView do
  use ApiWeb, :view

  def render("index.json", %{data: dishes}) do
    %{
      object: "dish",
      data: Enum.map(dishes, &dish_json/1)
    }
  end

  defp dish_json(dish) do
    %{
      id: dish.id,
      name: dish.name,
      type: dish.type,
      image_url: dish.image_url,
      restaurant_name: dish.restaurant.name,
      restaurant_category: dish.restaurant.category
    }
  end
end
