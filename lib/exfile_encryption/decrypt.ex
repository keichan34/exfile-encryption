defmodule ExfileEncryption.Decrypt do
  @moduledoc """
  Decrypts a file.
  """

  @behaviour Exfile.Processor

  alias Exfile.LocalFile
  import ExfileEncryption.Utilities

  def call(file, _args, opts) do
    keys = keys_from_opts(opts)

    with  {:ok, f}    <- LocalFile.open(file),
          {:ok, data} <- read_data(f),
          :ok         <- File.close(f),
          do: do_decrypt(data, keys)
  end

  defp do_decrypt(<<1, rest :: binary>>, keys) do
    <<
      tag_size :: size(8),
      tag :: binary-size(tag_size),
      iv_size :: size(8),
      iv :: binary-size(iv_size),
      cipher_text :: binary
    >> = rest

    Enum.find_value keys, {:error, :invalid_key}, fn(key) ->
      case decrypt_data({cipher_text, tag}, key, iv) do
        :error ->
          false
        data ->
          {:ok, write_to_local_file(data)}
      end
    end
  end
  defp do_decrypt(<<unsupported_version :: size(8), _ :: binary>>, _) do
    raise("This version of ExfileEncryption doesn't support file format version #{unsupported_version}. Please upgrade.")
  end

  defp write_to_local_file(data) do
    temp = Exfile.Tempfile.random_file!("exfile-encryption")
    {:ok, :ok} = File.open temp, [:write, :binary], fn(f) ->
      IO.binwrite(f, data)
    end
    %LocalFile{path: temp}
  end

  defp read_data(io) do
    case IO.binread(io, :all) do
      :eof -> {:error, :eof}
      {:error, _} = error -> error
      data -> {:ok, data}
    end
  end

  defp keys_from_opts(opts) do
    case Keyword.fetch(opts, :key) do
      {:ok, key} -> [key]
      :error ->
        keys = Keyword.get(opts, :keys, [])
        if length(keys) == 0,
          do: raise(ArgumentError, message: "decrypt requires a key")
        keys
    end
  end
end
