defmodule PipeWhileOkTest do
  use ExUnit.Case

  use Exlibris.PipeWhileOk

  test "basic pipes still work" do
    result = 123
             |> double
             |> inject_error
             |> elem(1)

    assert result == "{:ok, 246} is invalid"
  end

  test "pipe with everything OK processes OK" do
    result = pipe_while_ok do
      ok(123)
      |> double
      |> add_one
    end
    assert result == {:ok, 247}
  end

  test "pipe that fails first thing" do
    result = pipe_while_ok do
      inject_error(123)
      |> double
      |> add_one
    end
    assert result == {:error, "123 is invalid"}
  end

  test "pipe that fails in the middle" do
    result = pipe_while_ok do
      ok(123)
      |> double
      |> inject_error
      |> add_one
    end
    assert result == {:error, "246 is invalid"}
  end

  test "pipe that fails at the end" do
    result = pipe_while_ok do
      ok(123)
      |> double
      |> add_one
      |> inject_error
    end
    assert result == {:error, "247 is invalid"}
  end
  
  def inject_error(value) do
    {:error, "#{inspect value} is invalid"}
  end

  def ok(value),      do: {:ok, value}
  def double(value),  do: ok(value*2)
  def add_one(value), do: ok(value+1)
    
end
