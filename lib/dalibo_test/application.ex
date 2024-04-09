defmodule DaliboTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DaliboTestWeb.Telemetry,
      DaliboTest.Repo,
      {DNSCluster, query: Application.get_env(:dalibo_test, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DaliboTest.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: DaliboTest.Finch},
      # Start a worker by calling: DaliboTest.Worker.start_link(arg)
      # {DaliboTest.Worker, arg},
      # Start to serve requests, typically the last entry
      DaliboTestWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DaliboTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DaliboTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
