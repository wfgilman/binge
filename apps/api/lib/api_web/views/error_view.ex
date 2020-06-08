defmodule ApiWeb.ErrorView do
  use ApiWeb, :view

  def render("404.json", %{message: message}) do
    %{
      code: "not_found_error",
      message: message
    }
  end

  def render("404.json", _assigns) do
    %{
      code: "not_found_error",
      message: "We couldn't find the resource you requested."
    }
  end

  def render("500.json", _assigns) do
    %{
      code: "api_error",
      message: "Your request couldn't be processed."
    }
  end

  def render("query_params.json", _assigns) do
    %{
      code: "invalid_request_error",
      message: "The query parameters you specified are invalid."
    }
  end

  def render("changeset.json", %{data: %Ecto.Changeset{} = changeset}) do
    %{
      code: "validation_error",
      message: ApiWeb.ErrorHelpers.error_string_from_changeset(changeset)
    }
  end

  def render("rate_limit.json", _assigns) do
    %{
      code: "rate_limit_error",
      message: "You sent too many requests too fast. Slow down!"
    }
  end

  def render("twilio.json", %{message: message}) do
    %{
      code: "sms_error",
      message: message
    }
  end

  def render("invalid_code.json", _assigns) do
    %{
      code: "validation_error",
      message: "Sorry, that code is invalid or expired."
    }
  end

  def render("token.json", %{message: message}) do
    %{
      code: "authentication_error",
      message: "Invalid access token. #{message}"
    }
  end

  def template_not_found(template, _assigns) do
    %{
      code: "template_not_found",
      message: Phoenix.Controller.status_message_from_template(template)
    }
  end
end
