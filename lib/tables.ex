defmodule BShare.Tables do
  @moduledoc """
  """

  use GenServer

  @name TABLES

  ##############
  # Client API #
  ##############

  @doc """
  """
  @spec start_link(list) :: {atom, pid}
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  @doc """
  """
  @spec get_bike() :: integer
  def get_bike() do
    GenServer.call(@name, :get_bike)
  end

  @doc """
  """
  @spec has_bike?(map) :: boolean
  def has_bike?(user) do
    GenServer.call(@name, {:has_bike, user})
  end

  @doc """
  """
  def check_in(user) do
    GenServer.cast(@name, {:check_in, user})
  end

  @doc """
  """
  def check_out(user, bike_num) do
    GenServer.cast(@name, {:check_out, user, bike_num})
  end

  #######################
  # GenServer callbacks #
  #######################

  def init(:ok) do
    bike_table = :ets.new(:bikes, [:named_table])
    for n <- Enum.to_list(1..8), do: :ets.insert(:bikes, {n, true})
    user_table = :ets.new(:users, [:named_table])
    {:ok, {bike_table, user_table}}
  end

  def handle_call({:has_bike, user}, _from, state) do
    case :ets.lookup(:users, user["email"]) do
      [{_, bike_num}] ->
        if bike_num == 0 do
          {:reply, false, state}
        else
          {:reply, true, state}
        end

      [] ->
        :ets.insert(:users, {user["email"], 0})
        {:reply, false, state}

      _ ->
        {:reply, :error, state}
    end
  end

  def handle_call(:get_bike, _from, state) do
    [[bike_num] | _] = Enum.sort(:ets.match(:bikes, {:"$1", true}))
    {:reply, bike_num, state}
  end

  def handle_call({:check_in, user}, _from, state) do
    [{_, bike_num} | _] = :ets.lookup(:users, user["email"])
    :ets.insert(:bikes, {bike_num, true})
    :ets.insert(:users, {user["email"], 0})
    {:reply, bike_num, state}
  end

  def handle_cast({:check_out, user, bike_num}, state) do
    :ets.insert(:bikes, {bike_num, false})
    :ets.insert(:users, {user["email"], bike_num})
    {:noreply, state}
  end

  ####################
  # helper functions #
  ####################
end
