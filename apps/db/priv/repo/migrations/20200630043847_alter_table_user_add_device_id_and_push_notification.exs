defmodule Db.Repo.Migrations.AlterTableUserAddDeviceIdAndPushNotification do
  use Ecto.Migration

  def change do
    alter table("user") do
      add :device_token, :string
      add :push_enabled, :bool, null: false, default: false
    end
  end
end
