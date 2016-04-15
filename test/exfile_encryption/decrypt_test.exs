defmodule ExfileEncryption.DecryptTest do
  use ExUnit.Case, async: true

  alias Exfile.LocalFile

  @encryption_key "XZipUzP9O1PfDMM06rim"

  test "it can decrypt version 1 files" do
    plaintext_path = EETH.fixture_path("plaintext.txt")
    {:ok, plaintext} = File.open plaintext_path, [:binary], fn(f) ->
      IO.binread(f, :all)
    end

    path = EETH.fixture_path("version_1_encrypted.bin")
    file = %LocalFile{path: path}
    {:ok, decrypted_file} = ExfileEncryption.Decrypt.call(file, [key: @encryption_key], [])

    {:ok, decrypted_f} = LocalFile.open(decrypted_file)
    decrypted_text = IO.binread(decrypted_f, :all)

    assert plaintext == decrypted_text
  end
end
