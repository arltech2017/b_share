defmodule BShare.Router do
  alias BShare.{Auth, Tables, HOTP}

  def get_token(token) do
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
      HOTP.get_key(bike_num)
    else
      ""
    end
  end
end
