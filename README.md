# ExfileEncryption

[![Build Status](https://travis-ci.org/keichan34/exfile-encryption.svg?branch=master)](https://travis-ci.org/keichan34/exfile-encryption)

Transparent backend encryption / decryption for [Exfile](https://github.com/keichan34/exfile).

ExfileEncryption uses AES-GCM in 256-bit key mode. The file format is [documented](https://hexdocs.pm/exfile_encryption/file_format_1.html).

## Installation

1. Add `exfile_encryption` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:exfile_encryption, "~> 0.0.1"}]
end
```

2. Ensure `exfile_encryption` is started before your application:

```elixir
def application do
  [applications: [:exfile_encryption]]
end
```

## Usage

`exfile_encryption` registers two processors.

* `encrypt`
* `decrypt`

`encrypt` accepts a single argument, `key`: a string that will be hashed with SHA-256
and used as the encryption key. Note that while the key is not salted, a random IV
is generated for each file.

`decrypt` accepts either `key` with a single key or a list of accepted keys in `keys`.

## Configuration

`exfile_encryption` is designed to be used with Exfile's pre- and post-processing support.

Sample configuration of a backend that uses `exfile_encryption` to encrypt files stored on the "store" store

```elixir
config :exfile, Exfile,
  backends: %{
    "store" => {Exfile.Backend.FileSystem,
      directory: "/var/lib/my-store",
      max_size: nil,
      hasher: Exfile.Hasher.Random,
      preprocessors: [{"encrypt", [], [key: "don't tell anyone!"]}],
      postprocessors: [{"decrypt", [], [key: "don't tell anyone!"]}]
    }
  }
```

Sample configuration of a backend that will encrypt newly uploaded files with one
key, but accept multiple decryption keys. See [Issue #1](https://github.com/keichan34/exfile-encryption/issues/1)
to see when / why this should be used.

```elixir
config :exfile, Exfile,
  backends: %{
    "store" => {Exfile.Backend.FileSystem,
      directory: "/var/lib/my-store",
      max_size: nil,
      hasher: Exfile.Hasher.Random,
      preprocessors: [{"encrypt", [], [key: "don't tell anyone!"]}],
      postprocessors: [{"decrypt", [], [keys: ["don't tell anyone!", "old key"]]}]
    }
  }
```
