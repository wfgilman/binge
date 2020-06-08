defmodule ApiWeb.UserView do
  use ApiWeb, :view

  def render("show.json", %{data: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      phone: user.phone,
      email: user.email,
      match_user: match_user_json(user.match_user)
    }
  end

  defp match_user_json(nil), do: nil

  defp match_user_json(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      phone: user.phone,
      email: user.email
    }
  end
end
