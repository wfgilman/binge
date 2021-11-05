defmodule ApiWeb.UserView do
  use ApiWeb, :view

  def render("show.json", %{data: user}) do
    user_json(user)
  end

  def render("index.json", %{data: friends}) do
    %{
      count: Enum.count(friends),
      data: Enum.map(friends, &user_json/1)
    }
  end

  defp user_json(nil), do: nil

  defp user_json(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      phone: user.phone,
      email: user.email,
      status: user.status,
      friend_id: user.friend_id,
      push_enabled: user.push_enabled
    }
  end
end
