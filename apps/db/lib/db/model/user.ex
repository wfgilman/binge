defmodule Db.Model.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:phone, :string)
    field(:email, :string)
    field(:verify_code, :string)
    field(:verify_expiry, :integer)
    field(:status, Db.Enum.UserStatus)
    belongs_to(:match_user, Db.Model.User)
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [
      :first_name,
      :last_name,
      :phone,
      :email,
      :verify_code,
      :verify_expiry,
      :status,
      :match_user_id
    ])
    |> validate_required([:first_name, :phone, :status])
    |> validate_length(:phone, is: 10)
    |> unique_constraint(:phone)
    |> unique_constraint(:email)
  end
end
