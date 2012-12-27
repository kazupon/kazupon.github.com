---
state: published
tags: Lua,LuaJIT,kyotocabinet
date: '2012-05-28 15:20:00 GMT'
format: markdown
slug: kyotocabinet-lua-luajit
title: kyotocabinetのLuaバインディングをLuaJITバインディングにしてみた
id: 23931309864
type: text
---
ゲーム屋でだいぶ人気のスクリプト言語であるLua、そのJITコンパイラで鬼のように速いと言われている[LuaJIT][1]を、厨二的にkyotocabinetのLuaバインディング(以下kyotocabinet-lua)のエンジンをLuaから変えても速くなるだろうと思いやってみた。

# マシン環境（追記）
マシン環境は以下のとおり。

- Macbook Air 
- OS: Mac OS X 10.6.8
- CPU: 2.13 GHz Intel Core 2 Duo
- Memory: 4 GB 1067 MHz DDR3 SDRAM
- HDD: 256GB (APPLE SSD TS256C)

# 使ったLuaJITのバージョン
最新版は[LuaJIT 2.0.0-beta10][2]はみたいなので、これをダウンロード、ビルドして計測してみる。

# 使ったkyotocabinet-luaのバージョン
公式サイトの[ダウンロード先][3]にある最新のバージョン[1.28][4]を利用する。

# 計測方法
バイナリは以下の2種類準備する。

1. kyotocabinet-luaをそのままLuaのライブラリでビルドしたもの(以下、kyotocabinet-lua)
2. kyotocabinet-luaをLuaJITライブラリ向けに修正した`configure`でビルドしたもの(以下、kyotocabinet-luajit)

計測は、`make check`をただ単純に`time`コマンドで計る。途中、ゴニョゴニョと出力されるけど気にしない。

# 計測結果
何回かやった結果、以下な感じなった。計測データは、適当にピックアップしたもの。

## kyotocabinet-lua

    $ time make check
    real    1m36.956s
    user    0m37.854s
    sys     0m35.894s

## kyotocabinet-luajit

    $ time make check
    real    1m20.389s
    user    0m29.936s
    sys     0m33.130s

劇的というわけでありませんが、kyotocabinetもLuaからLuaJITに切り替えるだけで、速くなりますね。

# まとめ
kyotocabinet-luaをLuaからLuaJITに切り替えると速くなることがわかりました。
kyototycoonもLuaを使っているのでLuaJITで試してみる価値がありそうです。

# ソース（追記）
[github][5]においておきました。


[1]: http://luajit.org/
[2]: http://luajit.org/download.html
[3]: http://fallabs.com/kyotocabinet/luapkg/
[4]: http://fallabs.com/kyotocabinet/luapkg/kyotocabinet-lua-1.28.tar.gz
[5]: https://github.com/kazupon/kyotocabinet-lua
