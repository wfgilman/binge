defmodule Core.Dish do
  import Ecto.Query

  @spec list() :: [Db.Model.Dish.t()]
  def list() do
    Db.Model.Dish
    |> Db.Repo.all()
    |> Db.Repo.preload(:restaurant)
    |> Enum.shuffle()
  end

  @spec list(Db.Model.User.t()) :: [Db.Model.Dish.t()]
  def list(user) do
    dish_ids = get_dish_ids(user.id)
    friend_dish_ids = get_dish_ids(user.friend_id)

    list()
    |> Enum.reject(fn dish -> Enum.any?(dish_ids, &(&1 == dish.id)) end)
    |> add_match(friend_dish_ids)
  end

  @spec get_likes(Db.Model.User.t()) :: [Db.Model.Dish.t()]
  def get_likes(user) do
    dish_ids = get_dish_ids(user.id)
    friend_dish_ids = get_dish_ids(user.friend_id)

    Db.Repo.all(
      from(d in Db.Model.Dish,
        join: r in assoc(d, :restaurant),
        preload: [restaurant: r],
        where: d.id in ^dish_ids
      )
    )
    |> add_match(friend_dish_ids)
  end

  defp add_match(dishes, dish_ids) do
    Enum.map(dishes, fn dish ->
      Map.put(dish, :match, Enum.any?(dish_ids, &(&1 == dish.id)))
    end)
  end

  @spec get_matches(Db.Model.User.t()) :: [Db.Model.Dish.t()]
  def get_matches(user) do
    dish_ids = get_dish_ids(user.id)
    friend_dish_ids = get_dish_ids(user.friend_id)

    matching_dish_ids =
      dish_ids
      |> MapSet.new()
      |> MapSet.intersection(MapSet.new(friend_dish_ids))
      |> MapSet.to_list()

    Db.Repo.all(
      from(d in Db.Model.Dish,
        join: r in assoc(d, :restaurant),
        preload: [restaurant: r],
        where: d.id in ^matching_dish_ids,
        select_merge: %{match: true}
      )
    )
  end

  defp get_dish_ids(nil), do: []

  defp get_dish_ids(user_id) do
    :dish_likes
    |> :ets.match({{user_id, :_}, {:"$1", :_}})
    |> List.flatten()
  end

  @spec like(integer, integer, integer) :: boolean
  def like(user_id, dish_id, restaurant_id) do
    :ets.insert(:dish_likes, {{user_id, dish_id}, {dish_id, restaurant_id}})
  end

  @spec unlike(integer, integer) :: boolean
  def unlike(user_id, dish_id) do
    :ets.delete(:dish_likes, {user_id, dish_id})
  end
end
