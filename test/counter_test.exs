defmodule CounterTest do
  use ExUnit.Case, async: true
  doctest BShare.Counter

  alias BShare.Counter

  setup do
    {:ok, counter} = Counter.start_link()
    %{c: counter}
  end

  test "can create a counter and get the pid", %{c: counter} do
    assert is_pid(counter)
  end

  test "counter has an initail state of 0", %{c: counter} do
    assert Counter.get(counter) == 0
  end

  test "counter increases by 1 when acsessed", %{c: counter} do
    values = for _ <- 0..10, do: Counter.get(counter)
    assert values == Enum.to_list(0..10)
  end

  test "counter can be set to a value", %{c: counter} do
    Counter.set(counter, 10)
    assert Counter.get(counter) == 10
  end
end
