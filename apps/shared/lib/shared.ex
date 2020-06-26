defmodule Shared do
  def to_seconds({sec, :second}), do: sec
  def to_seconds({sec, :seconds}), do: sec
  def to_seconds({min, :minute}), do: min * 60
  def to_seconds({min, :minutes}), do: min * 60
  def to_seconds({hrs, :hour}), do: hrs * 60 * 60
  def to_seconds({hrs, :hours}), do: hrs * 60 * 60

  def to_milliseconds(param), do: to_seconds(param) * 1_000
end
