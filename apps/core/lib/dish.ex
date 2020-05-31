defmodule Core.Dish do
  import Ecto.Query

  def like(user_id, dish_id, restaurant_id) do
    :ets.insert(:dish_likes, {{user_id, dish_id}, {dish_id, restaurant_id}})
  end

  def unlike(user_id, dish_id) do
    :ets.delete(:dish_likes, {user_id, dish_id})
  end

  def get_likes(user_id) do
    dish_ids =
      :ets.match(:dish_likes, {{user_id, :"_"}, {:"$1", :"_"}})
      |> List.flatten()

    Db.Repo.all(
      from(d in Db.Model.Dish,
        join: r in assoc(d, :restaurant),
        preload: [restaurant: r],
        where: d.id in ^dish_ids)
    )
  end
end
