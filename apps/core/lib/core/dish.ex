defmodule Core.Dish do
  import Ecto.Query
  import Shared

  @dish_ttl {2, :hours}

  @spec list() :: [Db.Model.Dish.t()]
  def list() do
    from(d in Db.Model.Dish,
      join: r in assoc(d, :restaurant),
      preload: [restaurant: r]
    )
    |> Db.Repo.all()
    |> Enum.shuffle()
  end

  @spec list(Db.Model.User.t()) :: [Db.Model.Dish.t()]
  def list(user) do
    dish_ids = get_dish_ids(user.id)
    friend_dish_ids = get_dish_ids(user.friend_id)
    friend_rest_ids = get_restaurant_ids(user.friend_id)

    list()
    |> Enum.reject(fn dish -> Enum.any?(dish_ids, &(&1 == dish.id)) end)
    |> add_dish_matches(friend_dish_ids)
    |> add_restaurant_matches(friend_rest_ids)
  end

  @spec get_likes(Db.Model.User.t()) :: [Db.Model.Dish.t()]
  def get_likes(user) do
    dish_ids = get_dish_ids(user.id)
    friend_dish_ids = get_dish_ids(user.friend_id)
    friend_rest_ids = get_restaurant_ids(user.friend_id)

    Db.Repo.all(
      from(d in Db.Model.Dish,
        join: r in assoc(d, :restaurant),
        preload: [restaurant: r],
        where: d.id in ^dish_ids
      )
    )
    |> add_dish_matches(friend_dish_ids)
    |> add_restaurant_matches(friend_rest_ids)
  end

  defp add_dish_matches(dishes, dish_ids) do
    Enum.map(dishes, fn dish ->
      Map.put(dish, :match, Enum.any?(dish_ids, &(&1 == dish.id)))
    end)
  end

  defp add_restaurant_matches(dishes, restaurant_ids) do
    Enum.map(dishes, fn dish ->
      put_in(dish.restaurant.match, Enum.any?(restaurant_ids, &(&1 == dish.restaurant_id)))
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

    friend_rest_ids = get_restaurant_ids(user.friend_id)

    Db.Repo.all(
      from(d in Db.Model.Dish,
        join: r in assoc(d, :restaurant),
        preload: [restaurant: r],
        where: d.id in ^matching_dish_ids,
        or_where: d.restaurant_id in ^friend_rest_ids
      )
    )
    |> add_dish_matches(friend_dish_ids)
    |> add_restaurant_matches(friend_rest_ids)
    |> Enum.filter(&(&1.id in dish_ids))
  end

  defp get_dish_ids(nil), do: []

  defp get_dish_ids(user_id) do
    :dish_likes
    |> :ets.match({{user_id, :_}, {:"$1", :_, :_}})
    |> List.flatten()
  end

  defp get_restaurant_ids(nil), do: []

  defp get_restaurant_ids(user_id) do
    :dish_likes
    |> :ets.match({{user_id, :_}, {:_, :"$1", :_}})
    |> List.flatten()
    |> Enum.uniq()
  end

  @spec like(integer, integer, integer) :: boolean
  def like(user_id, dish_id, restaurant_id) do
    expiry = :os.system_time(:seconds) + to_seconds(@dish_ttl)
    :ets.insert(:dish_likes, {{user_id, dish_id}, {dish_id, restaurant_id, expiry}})
  end

  @spec unlike(integer, integer) :: boolean
  def unlike(user_id, dish_id) do
    :ets.delete(:dish_likes, {user_id, dish_id})
  end
end
