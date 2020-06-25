defmodule Db.Model.Restaurant do
  use Ecto.Schema

  schema "restaurant" do
    field(:name, :string)
    field(:category, :string)
    field(:address, :string)
    field(:phone, :string)
    field(:website, :string)
    field(:doordash_url, :string)
    field(:match, :boolean, virtual: true, default: false)
    timestamps()
  end
end
