defmodule Db.Repo.Migrations.CreateTableMatch do
  use Ecto.Migration

  def change do
    create table("match") do
      add :user_id, references(:user, on_delete: :delete_all)
      add :friend_id, references(:user, on_delete: :delete_all)
      timestamps()
    end

    create unique_index("match", [:user_id, :friend_id])
  end
end
