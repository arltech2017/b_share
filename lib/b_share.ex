defmodule BShare do
  use Application

  def start(_type, _args) do
    children = [
        {Plug.Adapters.Cowboy2, scheme: :http, plug: BShare.Router, options: [port: 8080]},
        {BShare.HOTP, []},
        {BShare.Tables, []}
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
