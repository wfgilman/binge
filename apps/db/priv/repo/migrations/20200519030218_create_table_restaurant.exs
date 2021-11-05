defmodule Db.Repo.Migrations.CreateTableRestaurant do
  use Ecto.Migration

  def change do
    create table("restaurant") do
      add :name, :string
      add :address, :string
      add :phone, :string
      add :website, :string
      add :doordash_url, :string
      add :instagram, :string
      add :filename, :string
      timestamps()
    end

    create unique_index("restaurant", [:name])
  end
end
