defmodule ExfileEncryption.Encrypt do
  @moduledoc """
  Encrypts a file.
  """

  @behaviour Exfile.Processor

  alias Exfile.LocalFile
  import ExfileEncryption.Utilities

  @file_version 1

  def call(file, args, _opts) do
    with  {:ok, f} <- LocalFile.open(file),
          do: do_encrypt(IO.binread(f, :all), args)
  end

  defp do_encrypt(:eof, _),
    do: {:error, :eof}
  defp do_encrypt({:error, _} = error, _),
    do: error
  defp do_encrypt(iodata, args) do
    key = Keyword.get(args, :key) ||
      raise(ArgumentError, message: "encrypt requires a key")
    iv = generate_iv
    encrypted = encrypt_data(iodata, key, iv)
    {:ok, write_to_local_file(encrypted, iv)}
  end

  defp write_to_local_file({cipher_text, cipher_tag}, iv) do
    temp = Exfile.Tempfile.random_file!("exfile-encryption")
    {:ok, :ok} = File.open temp, [:write, :binary], fn(f) ->
      IO.binwrite(f, [
        @file_version,
        byte_size(cipher_tag),
        cipher_tag,
        byte_size(iv),
        iv,
        cipher_text
      ])
    end
    %LocalFile{path: temp}
  end
end
