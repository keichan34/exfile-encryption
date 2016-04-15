defmodule ExfileEncryption.RegistrySync do
  @moduledoc false

  use GenServer

  alias Exfile.ProcessorRegistry, as: Registry

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    register_processors
    {:ok, :ok}
  end

  def code_change(_old_vsn, :ok, _extra) do
    register_processors
    {:ok, :ok}
  end

  defp register_processors do
    Registry.register("encrypt", ExfileEncryption.Encrypt)
    Registry.register("decrypt", ExfileEncryption.Decrypt)
  end
end
