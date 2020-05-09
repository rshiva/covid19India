defmodule Covidindia.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Covidindia.Repo,
      # Start the Telemetry supervisor
      CovidindiaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Covidindia.PubSub},
      # Start the Endpoint (http/https)
      CovidindiaWeb.Endpoint,
      # Start a worker by calling: Covidindia.Worker.start_link(arg)
      # {Covidindia.Worker, arg}
      {Cachex, :cache_warehouse}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Covidindia.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CovidindiaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
