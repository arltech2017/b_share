defmodule BShare.Auth do
  @moduledoc """

  """

  @doc """
  """
  @spec get_user(String.t) :: map
  def get_user(token) do
    HTTPoison.get!(
      "https://www.googleapis.com/oauth2/v2/userinfo?access_token=#{token}"
    ).body
    |> JSON.decode()
  end

  @doc """
  """
  @spec valid?(map) :: boolean
  def valid?(user) do
    user["hd"] == "apsva.us"
  end
end
