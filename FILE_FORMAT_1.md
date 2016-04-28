# File Format 1

The file format version `1` is specified with a `0x01` as the first byte of the file.
The second byte stores the length of cipher tag in bytes. The cipher tag follows
immediately.
The byte after the cipher tag stores the length of the IV in bytes (the default
is 12 bytes). The IV follows immediately.
All data after the IV is the ciphertext.

## Example

```
00000000: 0110 7ce2 513b a815 45de 8978 fe9e 38dc  ..|.Q;..E..x..8.
00000010: 2100 0c22 d7a1 98ba 026a 4c17 a753 dcd7  !..".....jL..S..
00000020: 73cb 96fe 121a f5c7 7502 3994 b4df b7d6  s.......u.9.....
00000030: 9c49 5d1c 2f83 5c70 095b 47e6 a8e8 3232  .I]./.\p.[G...22
...
```

* File format version: `0x01`
* Cipher tag length: `0x10` (16 bytes)
* Cipher tag: `7ce2 513b a815 45de 8978 fe9e 38dc 2100`
* IV length: `0x0c` (12 bytes)
* IV: `22 d7a1 98ba 026a 4c17 a753 dc`
* Ciphertext: `d7 73cb 96fe 121a f5c7 7502 3994 b4df b7d6 ...`
