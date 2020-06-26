defmodule Core.DishServer do
  use GenServer
  import Ex2ms
  import Shared

  @purge_interval {1, :minute}

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    send(__MODULE__, :purge)
    {:ok, state}
  end

  @impl true
  def handle_info(:purge, state) do
    timestamp = :os.system_time(:seconds)

    match_fun =
      fun do
        {{_user_id, _dish_id}, {_dish_id, _rest_id, expiry}} = obj when expiry < ^timestamp -> obj
      end

    :ets.select_delete(:dish_likes, match_fun)
    Process.send_after(__MODULE__, :purge, to_milliseconds(@purge_interval))
    {:noreply, state}
  end

  @impl true
  def handle_info(_msg, state), do: {:noreply, state}
end
