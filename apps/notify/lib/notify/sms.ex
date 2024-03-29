defmodule Notify.SMS do
  defstruct [:type, :args]
end

defimpl Notification, for: Notify.SMS do
  def send(%{type: "sms_code", args: [user, code]}) do
    number = user.phone
    message = "Your Binge verification code: #{code}"
    send_sms(number, message)
  end

  def send(%{type: "sms_invite", args: [user, friend]}) do
    number = friend.phone

    message =
      "#{user.first_name} wants to dine with you on Binge! " <>
        "Download the app to dine together 😛"

    send_sms(number, message)
  end

  defp send_sms(number, payload) do
    sms = %{
      to: "1#{number}",
      from: Application.get_env(:ex_twilio, :send_number),
      body: payload
    }

    ExTwilio.Api.create(ExTwilio.Message, sms)
  end
end
