defmodule ExfileEncryption do
  @moduledoc false

  use Application

  @doc false
  def start(_type, _args) do
    ExfileEncryption.Supervisor.start_link
  end
end
