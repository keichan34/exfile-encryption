ExUnit.start()

defmodule EETH do
  def fixture_path(name),
    do: Path.join(~w(support fixtures) ++ [name]) |> Path.expand(__DIR__)
end
