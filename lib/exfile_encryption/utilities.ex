defmodule ExfileEncryption.Utilities do
  @moduledoc false

  @aad "exfile-encryption-aad"

  @type key :: <<_ :: 256>>
  @type iv  :: <<_ :: 12 * 8>>
  @type encrypted :: {binary, binary}

  @spec compute_key(binary) :: key
  def compute_key(key),
    do: :crypto.hash(:sha256, key)

  # RFC 5084 3.2 specifies that the IV for AES-GCM can be any length between
  # 1 and 2^64 bits, but 12 octets is recommended.
  # https://tools.ietf.org/html/rfc5084#section-3.2
  @spec generate_iv :: iv
  def generate_iv, do: :crypto.rand_bytes(12)

  @spec encrypt_data(binary, key, iv) :: encrypted
  def encrypt_data(plain_text, key, iv),
    do: :crypto.block_encrypt(
      :aes_gcm, compute_key(key), iv, {@aad, plain_text})

  @spec decrypt_data(encrypted, key, iv) :: iodata | :error
  def decrypt_data({cipher_text, cipher_tag}, key, iv),
    do: :crypto.block_decrypt(
      :aes_gcm, compute_key(key), iv, {@aad, cipher_text, cipher_tag})
end
