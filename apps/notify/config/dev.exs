use Mix.Config

config :ex_twilio,
  account_sid: "ACf5d58cd330f96450b0a9d9e357d0687a",
  auth_token: "1a4a50de26a509f91231eefbb38787c2",
  send_number: "16195667131"

config :pigeon, :apns,
  apns_default: %{
    key: {:notify, "certs/AuthKey_D4WPZ39FN6.p8"},
    key_identifier: "D4WPZ39FN6",
    team_id: "QQ7F8UFQ5X",
    mode: :dev
  }
