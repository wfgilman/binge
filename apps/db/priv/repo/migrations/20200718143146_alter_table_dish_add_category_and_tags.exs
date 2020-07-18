defmodule Db.Repo.Migrations.AlterTableDishAddCategoryAndTags do
  use Ecto.Migration

  def change do
    alter table("dish") do
      add :category, :string
      add :tags, :string
    end
  end
end
