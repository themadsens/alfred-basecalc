# basecalc
A programmers calculator for [Alfred](https://www.alfredapp.com/)

Evaluates a Lua (v5.4) [numeric expression](https://www.lua.org/manual/5.4/manual.html#3.4)
and displays the result in the four main bases.
Everything from the [Lua math](https://www.lua.org/manual/5.4/manual.html#6.7) library is available,
and in addition `log10()` and `e`

In addition to decimal (42) and hexadecimal (0x2a), binary (0b101010) and octal (0o52) notation is available.
Uses '=' as the trigger keyword. Make sure to disable '=' for the built in calculator in Alfred Preferences/Features/Calculator.

Requires: Lua version 5.4
```
brew install lua
```

![screenshot](https://github.com/themadsens/alfred-pcalc/raw/master/pcalc.png "Screenshot")

Rational numbers are shown as nearest fraction too

![rationals](https://github.com/themadsens/alfred-pcalc/raw/master/rational.png "Rational numbers")

Initial placeholder hint

![placeholder](https://github.com/themadsens/alfred-pcalc/raw/master/placeholder.png "Placeholder")

