defmodule ExfileEncryption.EncryptTest do
  use ExUnit.Case, async: true

  alias Exfile.LocalFile

  @encryption_key "XZipUzP9O1PfDMM06rim"

  test "it works" do
    path = EETH.fixture_path("plaintext.txt")
    {:ok, plaintext} = File.open path, [:binary], fn(f) ->
      IO.binread(f, :all)
    end

    file = %LocalFile{path: path}
    {:ok, encrypted_file} = ExfileEncryption.Encrypt.call(file, [], [key: @encryption_key])

    {:ok, decrypted_file} = ExfileEncryption.Decrypt.call(encrypted_file, [], [key: @encryption_key])

    {:ok, decrypted_f} = LocalFile.open(decrypted_file)
    decrypted_text = IO.binread(decrypted_f, :all)

    assert plaintext == decrypted_text
  end

  test "raises an error if a key is not provided" do
    assert_raise ArgumentError, "encrypt requires a key", fn ->
      ExfileEncryption.Encrypt.call(nil, [], [])
    end
  end
end
