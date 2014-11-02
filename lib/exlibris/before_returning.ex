defmodule Exlibris.BeforeReturning do

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: [before_returning: 2]
      require unquote(__MODULE__)
    end
  end
  
  defmacro before_returning(val, do: block) do
    quote do
      result = unquote(val)
      case result, do: unquote(block)
      result
    end
  end

end
