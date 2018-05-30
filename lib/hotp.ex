defmodule BShare.HOTP do
  @moduledoc """
  A GenServer that calculates multiple HOTP values
  concurently.
  """

  use GenServer

  @name HOTP
  @secret "secret"

  ##############
  # Client API #
  ##############

  @doc """
  starts the HOTP genserver.
  """
  @spec start_link(list) :: {atom, pid}
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  @doc """
  gets a bike key to unlock the bike at `bike_num`
  """
  @spec get_key(integer) :: String.t
  def get_key(bike_num) do
    {_, key} = GenServer.call(@name, :get_key)
    key <> truncate(hmac(@secret, key <> "#{bike_num}"))
  end

  #######################
  # GenServer callbacks #
  #######################

  def init(:ok) do
    {:ok, c} = BShare.Counter.start_link
    {:ok, %{counter: c, secret: @secret}}
  end

  def handle_call(:get_key, _from, state) do
    c = BShare.Counter.get(state.counter)
    {:reply, {c, hmac(state.secret, "#{c}") |> truncate()}, state}
  end

  ####################
  # helper functions #
  ####################

  @doc """
  calculates an hmac as specified by RFC2104, with using
  `key` as they key and `text` as the message
  """
  @spec hmac(Stirng.t, String.t) :: integer
  def hmac(key, text) do
    :crypto.hmac(:sha256, key, text)
    |> Base.encode16()
    |> String.to_integer(16)
  end

  @doc """
  takes the first n digits of `num` and converts to a
  string padded with zeros as to be of length n. n is
  the value of `digits`.
  """
  @spec truncate(integer, integer) :: String.t
  def truncate(num, digits \\ 3) do
    num
    |> rem(trunc(:math.pow(10, digits)))
    |> Integer.to_string()
    |> String.pad_leading(digits, "0")
  end
end
