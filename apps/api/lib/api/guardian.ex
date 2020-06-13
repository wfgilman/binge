defmodule Api.Guardian do
  use Guardian, otp_app: :api

  def subject_for_token(%Db.Model.User{id: id}, _claims), do: {:ok, "User:#{id}"}

  def subject_for_token(_, _), do: {:error, "Unknown resource type."}

  def resource_from_claims(%{"sub" => "User:" <> id} = _claims) do
    case Db.Repo.get(Db.Model.User, id) do
      nil ->
        {:error, "Authorized user doesn't exist."}

      user ->
        {:ok, user}
    end
  end

  def resource_from_claims(_claims) do
    {:error, "Invalid access token."}
  end
end
