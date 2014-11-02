defmodule BeforeReturningTest do
  use ExUnit.Case

  use Exlibris.BeforeReturning

  test "value is returned after block executes" do
    result = before_returning(1+2) do
      val -> send(self, {:got, val})
    end
    assert result == 3
    assert_received {:got, 3}
  end

  test "the block pattern matches" do
    a = 1
    result = before_returning(a+2) do
      val when is_float(val) -> send(self, {:float, val})
      val -> send(self, {:not_float, val})
    end
    assert result == 3
    assert_received {:not_float, 3}
  end

end
