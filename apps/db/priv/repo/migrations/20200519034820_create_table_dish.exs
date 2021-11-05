defmodule Db.Repo.Migrations.CreateTableDish do
  use Ecto.Migration

  def change do
    create table("dish") do
      add :name, :string
      add :image_name, :string
      add :restaurant_id, references(:restaurant)
      timestamps()
    end

    create unique_index("dish", [:name, :restaurant_id])
  end
end
