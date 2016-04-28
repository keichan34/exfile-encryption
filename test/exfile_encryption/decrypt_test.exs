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
    {:ok, decrypted_file} = ExfileEncryption.Decrypt.call(file, [], [key: @encryption_key])

    {:ok, decrypted_f} = LocalFile.open(decrypted_file)
    decrypted_text = IO.binread(decrypted_f, :all)

    assert plaintext == decrypted_text
  end

  test "it can decrypt version 1 files with multiple keys" do
    plaintext_path = EETH.fixture_path("plaintext.txt")
    {:ok, plaintext} = File.open plaintext_path, [:binary], fn(f) ->
      IO.binread(f, :all)
    end

    path = EETH.fixture_path("version_1_encrypted.bin")
    file = %LocalFile{path: path}
    {:ok, decrypted_file} = ExfileEncryption.Decrypt.call(file, [], [keys: ["new key!", @encryption_key]])

    {:ok, decrypted_f} = LocalFile.open(decrypted_file)
    decrypted_text = IO.binread(decrypted_f, :all)

    assert plaintext == decrypted_text
  end

  test "it can not decrypt version 1 files with an invalid key" do
    path = EETH.fixture_path("version_1_encrypted.bin")
    file = %LocalFile{path: path}
    assert {:error, :invalid_key} = ExfileEncryption.Decrypt.call(file, [], [keys: ["new key!", "bad key."]])
  end

  test "it can not decrypt an unsupported file format (255)" do
    path = EETH.fixture_path("version_255_encrypted.bin")
    file = %LocalFile{path: path}
    assert_raise RuntimeError, "This version of ExfileEncryption doesn't support file format version 255. Please upgrade.", fn ->
      ExfileEncryption.Decrypt.call(file, [], [keys: ["new key!", @encryption_key]])
    end
  end

  test "raises an error if a key is not provided" do
    assert_raise ArgumentError, "decrypt requires a key", fn ->
      ExfileEncryption.Decrypt.call(nil, [], [])
    end

    assert_raise ArgumentError, "decrypt requires a key", fn ->
      ExfileEncryption.Decrypt.call(nil, [], [keys: []])
    end
  end
end
