defmodule Core.Match do
  import Ecto.Query

  @spec create(Db.Model.User.t(), Db.Model.User.t()) ::
          {:ok, Db.Model.Match.t()} | {:error, Ecto.Changeset.t()}
  def create(user, friend) do
    %Db.Model.Match{}
    |> Db.Model.Match.changeset(user, friend)
    |> Db.Repo.insert(on_conflict: :replace_all, conflict_target: [:user_id, :friend_id])
  end

  @spec list(Db.Model.User.t()) :: [Db.Model.User.t()]
  def list(user) do
    from(m in Db.Model.Match,
      join: u in assoc(m, :user),
      join: f in assoc(m, :friend),
      preload: [user: u, friend: f],
      where: u.id == ^user.id,
      or_where: f.id == ^user.id
    )
    |> Db.Repo.all()
    |> Enum.reduce([], fn match, acc ->
      acc ++ [match.user] ++ [match.friend]
    end)
    |> Enum.reject(&(&1.id == user.id))
    |> Enum.uniq()
  end

  @spec get(Db.Model.User.t()) :: Db.Model.User.t() | nil
  def get(user) do
    user
    |> Db.Repo.preload(:friend)
    |> Map.get(:friend)
  end
end
