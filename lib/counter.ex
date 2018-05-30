defmodule BShare.Counter do
  @moduledoc """
  this module implements a counter agent used for concurently
  generating HOTP keys. the counter agent Contains an integer
  that when acsessed increments by one.
  """

  use Agent

  @doc """
  creates a counter agent with a value of 0
  """
  @spec start_link(list) :: {:ok, pid}
  def start_link(_opts \\ []) do
    Agent.start_link(fn -> 0 end)
  end

  @doc """
  returns the value of `counter` and increases
  the agent's state by 1.
  """
  @spec get(pid) :: integer
  def get(counter) do
    Agent.get_and_update(counter, &({&1, 1 + &1}))
  end

  @doc """
  sets the counter agents state to `value`
  """
  @spec set(pid, integer) :: :ok
  def set(counter, value) do
    Agent.update(counter, fn _ -> value end)
  end
end
