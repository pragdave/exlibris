Exlibris
========

A collection of random functions that I've used in more than one project:

* **pipe_while_ok**

  Create pipelines that terminate early if any step fails to return a
  tuple that starts `{:ok, ...}`

* **before_returning**

  Like Ruby's `returning`, it evaluates its first argument, then evaluates the
  `do` block. It always returns the value of its first argument.

  The `do` block is like the body of a `case`, in that it receives the value
  of the first argument and patterns matches on it.

      before_returning File.open(name) do
        {:ok, _file} -> Logger.debug("#{name} opened OK")
        {:error, reason} -> Logger.error("Opening #{name}: #{:file.format_error(reason)}")
      end
            
