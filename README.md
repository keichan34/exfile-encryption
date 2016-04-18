# ExfileEncryption

[![Build Status](https://travis-ci.org/keichan34/exfile-encryption.svg?branch=master)](https://travis-ci.org/keichan34/exfile-encryption)

Encryption for Exfile files.

## Installation

1. Add exfile_encryption to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:exfile_encryption, "~> 0.0.1"}]
end
```

2. Ensure exfile_encryption is started before your application:

```elixir
def application do
  [applications: [:exfile_encryption]]
end
```

## Usage

`exfile_encryption` registers two processors. Each recieves a single argument, `key`, with the encryption key.

* `encrypt`
* `decrypt`

## Configuration

`exfile_encryption` is designed to be used with Exfile's pre- and post-processing support.

Sample configuration of a backend that uses `exfile_encryption` to encrypt files stored on the "store" store

```elixir
config :exfile, Exfile,
  backends: %{
    "store" => [Exfile.Backend.FileSystem, %{
      directory: "/var/lib/my-store",
      max_size: nil,
      hasher: Exfile.Hasher.Random,
      preprocessors: [{"encrypt", [], [key: "don't tell anyone!"]}],
      postprocessors: [{"decrypt", [], [key: "don't tell anyone!"]}]
    }]
  }
```
