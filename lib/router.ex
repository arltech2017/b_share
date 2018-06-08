defmodule BShare.Router do
  alias BShare.{Auth, Tables, HOTP}
  use Plug.Router
  use Plug.ErrorHandler

  plug(
    Plug.Parsers,
    parsers: [:json],
    json_decoder: JSON
  )

  plug(:match)
  plug(:dispatch)

  post "/authorize" do
    send_resp(conn, 201, "#{conn.body_params |> Map.fetch("token") |> elem(1) |> get_token()}")
  end

  match(_, do: send_resp(conn, 404, "not found"))

  @spec get_token(String.t) :: String.t
  defp get_token(token) do
    {:ok, user} = Auth.get_user(token)
    if Auth.valid?(user) do
      bike_num = case Tables.has_bike?(user) do
        true ->
          Tables.check_in(user)

        false ->
          num = Tables.get_bike()
          Tables.check_out(user, num)
          num
      end
      key = HOTP.get_key(bike_num)
    else
      ""
    end
  end
end
