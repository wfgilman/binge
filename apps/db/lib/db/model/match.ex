defmodule Db.Model.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "match" do
    belongs_to(:user, Db.Model.User)
    belongs_to(:friend, Db.Model.User)
    timestamps()
  end

  def changeset(match, user, friend) do
    match
    |> change()
    |> put_assoc(:user, user)
    |> put_assoc(:friend, friend)
    |> assoc_constraint(:user)
    |> assoc_constraint(:friend)
  end
end
