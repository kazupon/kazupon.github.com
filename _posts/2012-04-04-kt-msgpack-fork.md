---
state: published
tags: kyototycoon,msgpack,performance,msgpack-rpc
date: '2012-04-04 18:26:00 GMT'
format: markdown
slug: kt-msgpack-fork
title: kt-msgpackを改造してKyotoTycoonを操作できるProcedureを便利にしてみた
id: 20476065695
type: text
---
KyotoTycoon では`.so`、`.dylib`といった共有ライブラリによるプラグインをサポートとして、プラグインとして、memcachedプロトコルを実装したプラグインや、msgpack-rpcで使えるようにした [kt-msgpack][1] がある。
kt-msgpack では、msgpack-rpc を利用しているので、同期的なProcedureの呼び出しはもちろん、非同期なProcedureの呼び出しや、レスポンスを返さない通知的なProcedureの呼び出しでKyotoTycoonのデータをいじれるようになっている。
ですがですが、ソースを見てみると、KyotoTycoonで提供しているProcedureがあまりにも少ないことが分かったので、git にあるプロジェクトをforkしてちょっと充実させてみた。


# 充実させたProcedureたち
今回の改造で、充実&追加したProcedureは以下な感じ。

- ping
- echo
- status
- add
- set
- get
- remove
- append
- seize
- clear
- replace
- cas
- increment
- increment\_double
- match\_prefix
- match\_regex
- set\_bulk
- remove\_bulk
- get\_bulk
- vacuum
- synchronize

データ操作系や検索系、そしてバルク操作系があるので、これぐらいあれば何とかことは足りるかと。
`ping`という変な名前のProcedureがありますが、これは`void`に相当し、msgpack-rpcの制約(というかIDLからC++のコードを生成する[ツール][2]の制約?)でProcedureが別名にしています。
詳細は[ここ][3]のProceduresの一覧をご覧ください。


# サポートしなかったProcedureたち
今回諸事情サポートしなかったProcedureは以下な感じ。

- report
- play\_script
- tune\_replication
- cur\_jump
- cur\_jump\_back
- cur\_step
- cur\_step\_back
- cur\_set\_value
- cur\_remove
- cur\_get\_key
- cur\_get\_value
- cur\_get
- cur\_seize
- cur\_delete

`report`、`play_script`、`tune_replication` はちょっと作りこみ(場合によってはKyotoTycoonをいじる必要があるかも)が必要なので今回は対応していない。

`cur_xxx`系は、KyotoTycoonのアーキテクチャとmsgpack-rpc(mpio)のアーキテクチャが異なっているので、実装するのはちょっとしんどい。KyotoTycoonではセッション毎にローカルストレージにcursorオブジェクトを保持することで対応できているのだが、msgpack-rpc(mpio)では、KyotoTycoonのような感覚でセッションを使える仕組みがないので、同じ機能の実装はmsgpack-rpcを改造でもしない限りちょっと辛いところだ。(というより、自分がmsgpack-rpcに同じような機能があるのを知らないだけ?)

そもそも、cursorの操作については、KyotoTycoonの作者の[ブログ][4]に書いてある意見と同じく、ネットワーク越しに長期間リソースを占有するようなものは、サーバのリソースの無駄遣いだと思う。そのようなことをしたい場合は`play_script`のようなストアドプロシジャ的なスクリプトでcursor操作をして、さくっと用を足してしまえばいいと個人的に思っている。
なので、今後は、`cur_xxx`系のProcedureは対応しない方向で考えている。


# パフォーマンス測定
せっかく、Procedureを充実させたんで、一番気になるバルク系のデータ操作のパフォーマンスを測ってみた。
計測は5回行い、平均値を計る。サーバ、クライアントは同じマシン上で測定した。

## 測定プログラム
KyotoTycoon をインストールした際にバンドルされてくる`ktremotetest`とそれをkt-msgpackを向けに改変した、`ktmpremotetest`によって行う。
また、比較のため`ktremotetest`で、KyotoTycoonのHTTPとBinaryも計測する。
ちなみに、`ktmpremotetest`は今回改造した[こちら][3]から`git clone`してインストールすると、kt-msgpackといっしょにインストールされる。

## マシン環境
マシン環境は以下のとおり。

- Macbook (13-inch, Early 2009)
- OS: Mac OS X Lion 10.7.3
- CPU: 2 GHz Intel Core 2 Duo
- Memory: 4 GB 667 MHz DDR2 SDRAM
- HDD: 256GB (FUJITSU MHZ2250BH FFS G1 Media SATA)

## KyotoTycoonの起動オプション
KyotoTycoonの起動オプションは以下で起動する。

    $ ktserver -th 8 -lz -plsv /opt/local/libexec/libktmsgpack.dylib -plex "port=18801#thread=8" "casket.kct#bnum=2000000#opts=ls#ktopts=p"

- バケット数は100万レコードの2倍値(bnum=2000000)
- データベースオプションは、4バイトアドレッシング、線形リスト(opts=ls)
- パフォーマンスをちゃんと計測するために、KyotoTycoon側のスレッド数とkt-msgpackプラグインのスレッド数を同じ値に設定(-th 8, thread=8)
- ログ出力はなし(-lz)
- データは永続化(ktopts=p)

## 測定内容
KyotoTycoonの作者の[この記事][4]と同じことをする。サーバに対して、「00000001」「00000002」といった文字列のキーと値を持つレコード合計100万件の読み書きを行う。
以下のコマンド、set系9パターン、get系9パターン、計18パターンを計測する。

1. ktremotetest bulk -th 4 -set -bulk 1 250000
2. ktremotetest bulk -th 4 -set -bulk 10 250000
3. ktremotetest bulk -th 4 -set -bulk 100 250000
4. ktremotetest bulk -th 4 -set -bin -bulk 1 250000
5. ktremotetest bulk -th 4 -set -bin -bulk 10 250000
6. ktremotetest bulk -th 4 -set -bin -bulk 100 250000
7. ktmpremotetest bulk -th 4 -set -bulk 1 250000
8. ktmpremotetest bulk -th 4 -set -bulk 10 250000
9. ktmpremotetest bulk -th 4 -set -bulk 100 250000
10. ktremotetest bulk -th 4 -get -bulk 1 250000
11. ktremotetest bulk -th 4 -get -bulk 10 250000
12. ktremotetest bulk -th 4 -get -bulk 100 250000
13. ktremotetest bulk -th 4 -get -bin -bulk 1 250000
14. ktremotetest bulk -th 4 -get -bin -bulk 10 250000
15. ktremotetest bulk -th 4 -get -bin -bulk 100 250000
16. ktmpremotetest bulk -th 4 -get -bulk 1 250000
17. ktmpremotetest bulk -th 4 -get -bulk 10 250000
18. ktmpremotetest bulk -th 4 -get -bulk 100 250000

`-th`は、起動スレッド数を意味する。
`-set`は`set_bulk`によるレコード設定を意味する。
`-get`は`get_bulk`によるレコード設定を意味する。
`-bulk`は、バルク操作で一度に設定/取得するレコード数を意味する。
`ktremotetest`の`-bin`はBinaryプロトコルによるバルク設定/取得を意味する。このオプションがない場合は、HTTPプロトコルによるバルク設定/取得になる。

# 測定結果
100万件のバルク操作の計測結果は以下のようになった。

<table>
    <tr>
        <th></th>
        <th>計測1</th>
        <th>計測2</th>
        <th>計測3</th>
        <th>計測4</th>
        <th>計測5</th>
        <th>average</th>
    </tr>
    <tr>
        <td>1.HTTP set 1 bulk</td>
        <td>124.643</td>
        <td>126.641</td>
        <td>119.626</td>
        <td>125.788</td>
        <td>140.967</td>
        <td>127.533</td>
    </tr>
    <tr>
        <td>2.HTTP set 10 bulk</td>
        <td>20.731</td>
        <td>17.873</td>
        <td>15.776</td>
        <td>16.058</td>
        <td>15.281</td>
        <td>17.1438</td>
    </tr>
    <tr>
        <td>3.HTTP set 100 bulk</td>
        <td>7.052</td>
        <td>6.719</td>
        <td>8.246</td>
        <td>6.54</td>
        <td>6.778</td>
        <td>7.067</td>
    </tr>
    <tr>
        <td>4.Binary set 1 bulk</td>
        <td>70.699</td>
        <td>71.705</td>
        <td>66.925</td>
        <td>70.883</td>
        <td>70.841</td>
        <td>70.2106</td>
    </tr>
    <tr>
        <td>5.Binary set 10 bulk</td>
        <td>8.44</td>
        <td>9.193</td>
        <td>8.939</td>
        <td>9.877</td>
        <td>8.776</td>
        <td>9.045</td>
    </tr>
    <tr>
        <td>6.Binary set 100 bulk</td>
        <td>4.449</td>
        <td>4.923</td>
        <td>4.341</td>
        <td>4.412</td>
        <td>4.309</td>
        <td>4.4868</td>
    </tr>
    <tr>
        <td>7.msgpack-rpc set 1 bulk</td>
        <td>78.078</td>
        <td>85.017</td>
        <td>79.846</td>
        <td>77.657</td>
        <td>87.636</td>
        <td>81.6468</td>
    </tr>
    <tr>
        <td>8.msgpack-rpc set 10 bulk</td>
        <td>16.943</td>
        <td>14.585</td>
        <td>13.157</td>
        <td>13.645</td>
        <td>17.013</td>
        <td>15.0686</td>
    </tr>
    <tr>
        <td>9.msgpack-rpc set 100 bulk</td>
        <td>7.261</td>
        <td>7.19</td>
        <td>6.894</td>
        <td>7.659</td>
        <td>10.003</td>
        <td>7.8014</td>
    </tr>
    <tr>
        <td>10.HTTP get 1 bulk</td>
        <td>117.963</td>
        <td>124.22</td>
        <td>122.057</td>
        <td>120.705</td>
        <td>132.164</td>
        <td>123.4218</td>
    </tr>
    <tr>
        <td>11.HTTP get 10 bulk</td>
        <td>16.756</td>
        <td>19.225</td>
        <td>18.153</td>
        <td>18.522</td>
        <td>21.171</td>
        <td>18.7654</td>
    </tr>
    <tr>
        <td>12.HTTP get 100 bulk</td>
        <td>8.068</td>
        <td>8.733</td>
        <td>11.251</td>
        <td>9.193</td>
        <td>9.028</td>
        <td>9.2546</td>
    </tr>
    <tr>
        <td>13.Binary get 1 bulk</td>
        <td>61.831</td>
        <td>72.635</td>
        <td>74.087</td>
        <td>70.9</td>
        <td>75.88</td>
        <td>71.0666</td>
    </tr>
    <tr>
        <td>14.Binary get 10 bulk</td>
        <td>9.883</td>
        <td>10.741</td>
        <td>11.739</td>
        <td>10.249</td>
        <td>13.278</td>
        <td>11.178</td>
    </tr>
    <tr>
        <td>15.Binary get 100 bulk</td>
        <td>5.861</td>
        <td>7.47</td>
        <td>6.11</td>
        <td>6.061</td>
        <td>6.048</td>
        <td>6.31</td>
    </tr>
    <tr>
        <td>16.msgpack-rpc 1 bulk</td>
        <td>79.438</td>
        <td>89.539</td>
        <td>74.367</td>
        <td>92.129</td>
        <td>91.659</td>
        <td>85.4264</td>
    </tr>
    <tr>
        <td>17.msgpack-rpc 10 bulk</td>
        <td>18.262</td>
        <td>19.146</td>
        <td>16.453</td>
        <td>20.083</td>
        <td>19.446</td>
        <td>18.678</td>
    </tr>
    <tr>
        <td>18.msgpack-rpc 100 bulk</td>
        <td>11.175</td>
        <td>10.415</td>
        <td>10.667</td>
        <td>10.95</td>
        <td>14.237</td>
        <td>11.4888</td>
    </tr>
</table>

やっぱり、Binaryがパフォーマンスいいですね。msgpack-rpcも結構いい感じパフォーマンスでています。この計測結果からみると、パフォーマンスとしては、

    Binary > msgpack-rpc > HTTP

といった感じでしょうか。まあ、bulk操作で扱うデータ数を増やせば、まあそれなりの速度で処理することができるので、どれを利用しても実運用上特に問題ないかあと。同期、非同期の通信を柔軟に選択できつつ、パフォーマンスが確保できるっていうのがメリットなのかもしれない。(まあ、Node.jsを利用すれば、それできますけど。。。)


# まとめ
kt-msgpackをforkして、KyotoTycoonで提供するProcedureを充実させました。この改造により他の言語でもmsgpack-rpcを利用することで、set、getによるデータ操作、バルク一括操作、検索、そしてcas、incrementが利用できるようになりました。msgpack-rpcのバルク操作のパフォーマンスも、HTTPとBinaryの間なので、通信機能で柔軟にロジックを制御したいっていう場合には、KyotoTycoonを使うユースケースでは、kt-msgpackを選択するのはいいかもしれません。


[1]: https://github.com/frsyuki/kt-msgpack
[2]: https://github.com/msgpack/msgpack-rpc/tree/master/idl
[3]: https://github.com/kazupon/kt-msgpack
[4]: http://fallabs.com/blog-ja/promenade.cgi?id=96
[5]: http://fallabs.com/blog-ja/promenade.cgi?id=110
