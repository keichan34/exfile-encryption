defmodule ExfileEncryption.Utilities do
  @moduledoc false

  @aad "exfile-encryption-aad"

  def compute_key(key),
    do: :crypto.hash(:sha256, key)

  def generate_iv, do: :crypto.rand_bytes(12)

  def encrypt_data(plain_text, key, iv),
    do: :crypto.block_encrypt(
      :aes_gcm, compute_key(key), iv, {@aad, plain_text})

  def decrypt_data({cipher_text, cipher_tag}, key, iv),
    do: :crypto.block_decrypt(
      :aes_gcm, compute_key(key), iv, {@aad, cipher_text, cipher_tag})
end
