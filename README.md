# DosHack
Couple cracking dos programs for entering password

# Installing
1. Full setup of DosBox+VolkovCommander+ASM+IDA+THELP+...  : [ded32.net.ru/storage.ded32.ru/Materials/TXLib/dosbox-asm-setup.rar.exe](http://nas.ded32.ru/storage.ded32.ru/Materials/TXLib/dosbox-asm-setup.rar.exe)
2. Emulator of DosBox+Asm by yourself

# My vulnerability
[```CRYPTA.ASM```](https://github.com/khmelnitskiianton/DosHack/blob/main/CRYPTA.ASM) & [```CRYPTA.COM```](https://github.com/khmelnitskiianton/DosHack/blob/main/CRYPTA.COM)

Key is `1234<ENTER>`

## Weak hash-function (simple)

In first case my hash was simple, that you can choose password to enter

It counts summ of askii codes and you need only equal summ to 202d (summ of '1234' in askii)

## Overflowing stack (hard)

By checking for overflow flag of address I allow user to overflow stack, where situated address of return and user can switch it to jmp for success

In string 72: `je fail_case` - hidden check for flag ZF==1 that set if si is overflowing. That's why hacker can't overwrite all segment, but he has access to stack! 

In string 59: in stack put address of return and than after input in string 79 processor takes address to return and user can change it to `jmp success_case`. That's vulnerability to jmp my hashing.

# Opponent's vulnerability
[```HACKER.ASM```](https://github.com/khmelnitskiianton/DosHack/blob/main/HACKER.ASM) & [```HACKER.COM```](https://github.com/khmelnitskiianton/DosHack/blob/main/HACKER.COM)

By using IDA - disassembler, I have user's code with dump,comments,graphs and etc [```HACKER.i64```](https://github.com/khmelnitskiianton/DosHack/blob/main/HACKER.i64) 

```Full code:```

<img src="https://github.com/khmelnitskiianton/DosHack/assets/142332024/23516b17-8c49-4cd7-ab04-ead2eaed2c6b" width=70%>

He allocates his buffer before fucntions and has no checks for overflowing thats why I can overwrite everything

##  Noping hash(simple)
First simple solving is to change hash and data at the end. In hex  [```PWD1.TXT```](https://github.com/khmelnitskiianton/DosHack/blob/main/PWD1.TXT) consists of `skip buffer`-`nop hash`-`set ax = 0 for cmp`-`ret from hash`-`change true_hash on same val as ax`-`EOF = enter by input from file `

<img src="https://github.com/khmelnitskiianton/DosHack/assets/142332024/6925d747-fb97-43ad-b05c-9494b3b5a50c" width=60%>

`Result:`

<img src="https://github.com/khmelnitskiianton/DosHack/assets/142332024/e1750edb-c7c1-4eb1-848b-013cb050424f" width=40%>

## Overwrite segment(hard)
Similar to previous but overwrites all segment with starting too

It consists of `previous changes`-`many many zeros`-`after overflowing si at address 100h new commands for me, change dec si --- jmp success_case`

`Result:`

<img src="https://github.com/khmelnitskiianton/DosHack/assets/142332024/02204adf-4227-4d1c-815a-b99b4c60197b" width=40%>

`BUG:` It need to press enter and than DOS crashes, will fix
