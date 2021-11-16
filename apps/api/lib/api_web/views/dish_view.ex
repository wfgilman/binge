defmodule ApiWeb.DishView do
  use ApiWeb, :view

  @aws_s3_url Application.get_env(:shared, :aws_s3_url)

  def render("index.json", %{data: dishes}) do
    %{
      count: Enum.count(dishes),
      data: Enum.map(dishes, &dish_json/1)
    }
  end

  defp dish_json(dish) do
    %{
      id: dish.id,
      name: dish.name,
      image_url: "#{@aws_s3_url}#{dish.image_name}",
      match: dish.match,
      restaurant_id: dish.restaurant.id,
      restaurant_name: dish.restaurant.name,
      restaurant_match: dish.restaurant.match,
      doordash_url: dish.restaurant.doordash_url,
      website_url: dish.restaurant.website,
      phone: dish.restaurant.phone,
      instagram: dish.restaurant.instagram,
      ubereats_url: nil,
      restaurant_address: dish.restaurant.address
    }
  end
end
