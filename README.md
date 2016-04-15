# ExfileEncryption

[![Build Status](https://travis-ci.org/keichan34/exfile-encryption.svg?branch=master)](https://travis-ci.org/keichan34/exfile-encryption)

Encryption for Exfile files.

## Installation

1. Add exfile_encryption to your list of dependencies in `mix.exs`:

	def deps do
	  [{:exfile_encryption, "~> 0.0.1"}]
	end

2. Ensure exfile_encryption is started before your application:

	def application do
	  [applications: [:exfile_encryption]]
	end

## Usage

`exfile_encryption` registers a couple processors.

* `encrypt`
* `decrypt`
