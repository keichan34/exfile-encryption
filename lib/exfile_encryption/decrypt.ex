defmodule ExfileEncryption.Decrypt do
  @moduledoc """
  Decrypts a file.
  """

  @behaviour Exfile.Processor

  alias Exfile.LocalFile
  import ExfileEncryption.Utilities

  def call(file, args ,_opts) do
    with  {:ok, f} <- LocalFile.open(file),
          do: do_decrypt(IO.binread(f, 1), f, args)
  end

  defp do_decrypt(:eof, f, _) do
    File.close(f)
    {:error, :eof}
  end
  defp do_decrypt({:error, _} = error, f, _) do
    File.close(f)
    error
  end
  defp do_decrypt(<<1>>, f, args) do
    key = Keyword.get(args, :key) ||
      raise(ArgumentError, message: "decrypt requires a key")

    <<tag_byte_size>> = IO.binread(f, 1)
    tag = IO.binread(f, tag_byte_size)
    <<iv_byte_size>> = IO.binread(f, 1)
    iv = IO.binread(f, iv_byte_size)
    cipher_text = IO.binread(f, :all)

    case decrypt_data({cipher_text, tag}, key, iv) do
      :error ->
        {:error, :invalid_key}
      data ->
        {:ok, write_to_local_file(data)}
    end
  end
  defp do_decrypt(<<unsupported_version>>, f, _) do
    File.close(f)
    raise("This version of ExfileEncryption doesn't support file format version #{unsupported_version}. Please upgrade.")
  end

  defp write_to_local_file(data) do
    temp = Exfile.Tempfile.random_file!("exfile-encryption")
    {:ok, :ok} = File.open temp, [:write, :binary], fn(f) ->
      IO.binwrite(f, data)
    end
    %LocalFile{path: temp}
  end
end
