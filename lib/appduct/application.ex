defmodule Appduct.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Appduct.Worker.start_link(arg)
      # {Appduct.Worker, arg}
      {Bandit, plug: Appduct.Router, scheme: :http, ip: {127, 0, 0, 1}, port: 4001},
      Appduct.Writer.Reaction,
      Appduct.Db.Cubdb,
      Appduct.Db.Countdb
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Appduct.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
