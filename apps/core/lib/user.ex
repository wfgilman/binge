defmodule Core.User do
  import Ecto.Query

  @verify_code_ttl {5, :minutes}

  @spec create(%{String.t() => String.t()}) ::
          {:ok, Db.Model.User.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    params
    |> check_if_invited()
    |> Db.Model.User.changeset(params)
    |> Db.Repo.insert_or_update()
  end

  defp check_if_invited(%{"phone" => phone}) do
    case lookup_by_phone(phone) do
      nil ->
        %Db.Model.User{}

      user ->
        user
    end
  end

  defp lookup_by_phone(phone) do
    Db.Repo.get_by(Db.Model.User, phone: phone)
  end

  @spec generate_verification_code(integer | String.t()) :: Db.Model.User.t() | no_return
  def generate_verification_code(user_id) do
    code = "#{Enum.random(100_000..999_999)}"
    expiry = :os.system_time(:seconds) + to_seconds(@verify_code_ttl)

    Db.Model.User
    |> Db.Repo.get(user_id)
    |> Ecto.Changeset.change(%{verify_code: code, verify_expiry: expiry})
    |> Db.Repo.update!()
  end

  defp to_seconds({min, :minutes}), do: min * 60

  @spec verify_user(Db.Model.User.t(), String.t()) :: boolean
  def verify_user(user, code) do
    case lookup_by_code(user, code) do
      nil ->
        false

      user ->
        user
        |> Ecto.Changeset.change(%{status: :verified})
        |> Db.Repo.update!()

        true
    end
  end

  defp lookup_by_code(user, code) do
    from(u in Db.Model.User,
      where: u.id == ^user.id,
      where: u.verify_code == ^code,
      where: u.verify_expiry > ^:os.system_time(:seconds)
    )
    |> Db.Repo.one()
  end
end
