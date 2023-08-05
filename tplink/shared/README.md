### Commands

```shell
dd if=c6v4-up-noboot_2023-02-08_10.47.55.bin of=raw.lzma bs=1 skip=212
xxd raw.lzma | tee -a binary.txt
dd if=raw.lzma of=chunk.bin bs=1 skip=1560384 count=1533778
python extract.py chunk.bin
dd if=minifs.bin of=private.pem bs=1 skip=5867311
openssl pkey -in private.pem -pubout > public.pem
```

5820282-5822488