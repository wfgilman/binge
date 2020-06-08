defmodule ApiWeb.TokenView do
  use ApiWeb, :view

  def render("show.json", %{data: token}) do
    %{
      access_token: token
    }
  end
end
