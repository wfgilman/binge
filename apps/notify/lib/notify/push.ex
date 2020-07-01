defmodule Notify.Push do
  defstruct [:type, :args]
end

defimpl Notification, for: Notify.Push do
  require Logger

  def send(%{type: "match", args: [user, friend, restaurant_match]}) do
    handler = fn %Pigeon.APNS.Notification{response: resp, device_token: device_token} ->
      case resp do
        :bad_device_token ->
          Logger.info("Device Token not registered with Apple: #{device_token}")
          :ok

        resp ->
          Logger.info("Push sent with response: #{resp}")
          :ok
      end
    end

    message =
      if restaurant_match == true do
        "You and #{user.first_name} fancy the same restaurant! 🍽"
      else
        "Woohoo! You and #{user.first_name} want the same dish! 🎉"
      end

    send_notification(message, friend.device_token, handler)
  end

  defp send_notification(message, device_id, handler) do
    Pigeon.APNS.Notification.new(message, device_id, "BGHFM.Binge")
    |> Pigeon.APNS.Notification.put_sound("default")
    |> Pigeon.APNS.push(on_response: handler)
  end
end
