defmodule HOTPTest do
  use ExUnit.Case, async: true
  doctest BShare.HOTP

  alias BShare.HOTP

  test "calculates a hmac" do
    key = 107869147494729632300475088667914342461426032184081830543702794257724708364958
    assert HOTP.hmac("a key", "some message")
  end
end
