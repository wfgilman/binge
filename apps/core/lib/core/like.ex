defmodule Core.Like do

  defstruct dish_id: nil, restaurant_id: nil

  @type t :: %__MODULE__{dish_id: integer, restaurant_id: integer}

  @spec get_friend_likes(Db.Model.User.t) :: [Core.Like.t]
  def get_friend_likes(%Db.Model.User{friend_id: nil}), do: []

  def get_friend_likes(user) do
    :dish_likes
    |> :ets.match({{user.friend_id, :_}, {:"$1", :"$2", :_}})
    |> Enum.map(fn [dish_id, restaurant_id] ->
      %Core.Like{dish_id: dish_id, restaurant_id: restaurant_id}
    end)
  end
end
