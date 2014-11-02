defmodule Exlibris.PipeWhileOk do

  @moduledoc """

  PipeWhileOk
  ===========

  You want to use pipelines to transform data. That's good.

  But you also have a problem. Maybe you want to write:

      check_directory?(folder)
      |> check_no_existing_batch_for_folder?
      |> load_batch

  Looks good, and it's easy to read. But what happens if any of the
  steps detects an error? You want to bail out of the pipeline early.
  But the default pipeline doesn't know how to bail out, and will plug
  on regardless.

  Enter `pipe_while_ok`.

  This is based on work Bruce Tate did a [while
  back](https://github.com/batate/elixir-pipes), but simplified to
  handle just one case: terminating a pipe at any stage in the pipe
  fails to return an _OK_ status.

  It works based on a convention. Each function in the pipe should
  return the tuple `{ :ok, value }` if it is successful. In this case,
  the `value` is passed as the first parameter to the next function in
  the pipeline. If anything else is returned, the pipeline is terminated
  without further processing, and whatever was returned becomes the
  value returned by the pipeline.

  ## Example

      def create_batch(folder) do
        pipe_while_ok do
          check_directory?(folder)
          |> check_no_existing_batch_for_folder?
          |> load_batch 
        end
      end

      def check_directory?(folder) do
        cond do
          File.dir?(folder) ->
            { :ok, folder }
          true              ->
            { :batch_folder_does_not_exist, folder }
        end
      end

      def check_no_existing_batch_for_folder?(folder) do
        case Batch.for_folder(folder, Repo) do
          nil -> { :ok, folder }
          _   -> { :already_loaded_batch_for, folder }
        end
      end

      def load_batch(folder) do
        batch = Repo.insert(Batch{base_folder: folder})
        Batch.run(batch, folder)
        {:ok, batch, folder}
      end
  """
  
  defmacro __using__(_) do
    quote do
      import  unquote(__MODULE__)
    end
  end


  @doc @moduledoc
  
  defmacro pipe_while_ok(do: pipes) do
    _pipe_while_ok(pipes)
  end

  defp _pipe_while_ok(pipes) do
    [{h,_}|t] = Macro.unpipe(pipes)
    Enum.reduce t, h, &(reduce_matching(&1, &2))
  end

  defp reduce_matching({next_function, pos}, acc) do
    quote do
      case unquote(acc) do
        {:ok, val} -> unquote(Macro.pipe(quote(do: val), next_function, pos))
        error      -> error
      end
    end
  end

end
