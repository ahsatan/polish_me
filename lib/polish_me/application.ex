defmodule PolishMe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PolishMeWeb.Telemetry,
      PolishMe.Repo,
      {DNSCluster, query: Application.get_env(:polish_me, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PolishMe.PubSub},
      # Start a worker by calling: PolishMe.Worker.start_link(arg)
      # {PolishMe.Worker, arg},
      # Start to serve requests, typically the last entry
      PolishMeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PolishMe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PolishMeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
