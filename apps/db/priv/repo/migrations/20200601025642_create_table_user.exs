defmodule Db.Repo.Migrations.CreateTableUser do
  use Ecto.Migration

  def change do
    create table("user") do
      add :first_name, :string, null: false
      add :last_name, :string
      add :phone, :string, null: false
      add :email, :string
      add :verify_code, :string
      add :verify_expiry, :bigint
      add :status, :integer, null: false
      add :match_user_id, references(:user)
      timestamps()
    end

    create unique_index("user", [:phone])
    create unique_index("user", [:email])
  end
end
