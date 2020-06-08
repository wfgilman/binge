defmodule Core do
  use Application
  import Supervisor.Spec

  def start(_, _) do
    Supervisor.start_link(
      [
        supervisor(Eternal, [:dish_likes, [:set]])
      ],
      strategy: :one_for_one,
      name: Core.Supervisor
    )
  end
end
