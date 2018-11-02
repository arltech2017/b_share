defmodule BShare.Auth do
  @moduledoc """
    This module handles authentifcation of tokens.
  """

  @doc """
    gets the account data from an google oauth token
  """
  @spec get_user(String.t) :: map
  def get_user(token) do
    HTTPoison.get!(
      "https://www.googleapis.com/oauth2/v2/userinfo?access_token=#{token}"
    ).body
    |> JSON.decode()
  end

  @doc """
    checks whether an account is hotsted by APS
  """
  @spec valid?(map) :: boolean
  def valid?(user) do
    user["hd"] == "apsva.us"
  end
end
