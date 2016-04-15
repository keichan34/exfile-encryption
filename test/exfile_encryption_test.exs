defmodule ExfileEncryptionTest do
  use ExUnit.Case

  alias Exfile.ProcessorRegistry, as: Registry

  test "ExfileEncryption.Encrypt is loaded as `encrypt`" do
    assert \
      {:ok, ExfileEncryption.Encrypt}
      ==
      Registry.get_processor_module("encrypt")
  end

  test "ExfileEncryption.Decrypt is loaded as `decrypt`" do
    assert \
      {:ok, ExfileEncryption.Decrypt}
      ==
      Registry.get_processor_module("decrypt")
  end
end
