defmodule Db.Model.Dish do
  use Ecto.Schema

  schema "dish" do
    field(:name, :string)
    field(:image_url, :string)
    field(:type, :string)
    field(:category, :string)
    field(:tags, :string)
    field(:match, :boolean, virtual: true, default: false)
    belongs_to(:restaurant, Db.Model.Restaurant)
    timestamps()
  end
end
