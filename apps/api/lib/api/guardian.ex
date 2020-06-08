defmodule Api.Guardian do
  use Guardian, otp_app: :api

  def subject_for_token(%Db.Model.User{id: id}, _claims), do: {:ok, "User:#{id}"}

  def subject_for_token(_, _), do: {:error, "Unknown resource type."}

  def resource_from_claims(%{"sub" => "User:" <> id} = _claims) do
    user = Db.Repo.get(Db.Model.User, id)
    {:ok, user}
  end

  def resource_from_claims(_claims) do
    {:error, "User not found."}
  end
end
