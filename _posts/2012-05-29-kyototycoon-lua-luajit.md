---
state: published
tags: Lua,LuaJIT,kyototycoon
date: '2012-05-29 15:47:00 GMT'
format: markdown
slug: kyototycoon-lua-luajit
title: kyototycoonのLuaスクリプティング拡張をLuaJITにしてみた
id: 23999830992
type: text
---
[前回][1]のブログの続き。

MySQLのようなRDBMSでは、SQLの処理をサーバサイドで一撃打陣でできる、ストアドプロシジャというのがあるんだけど、[kyototycoon][2]のようなNoSQLなデータベースでもLuaを使えば、サーバサイドでKVSを組み合わせてテーブルDBを構築したり、mongoDB的なドキュメント指向的なDBを構築したりと、いろいろとゴニョゴニョできる機能がある。

kyototycoonでもLuaのエンジンをLuaJITにスイッチすれば速くなるんじゃね？だったら検証してみっか！という厨二的な調子になって性能測定してみたというお話。


# マシン環境
マシン環境は以下のとおり。前回のブログと同じ。

- Macbook Air
- OS: Mac OS X 10.6.8
- CPU: 2.13 GHz Intel Core 2 Duo
- Memory: 4 GB 1067 MHz DDR3 SDRAM
- HDD: 256GB (APPLE SSD TS256C)


# 使ったLuaJITのバージョン
前回と同じ[LuaJIT 2.0.0-beta10][3]。


# 使ったkyototycoonのバージョン
公式サイトの[ダウンロード先][4]にある最新のバージョン[0.9.56][5]を利用する。


# 測定方法
- 測定用に書いたLuaスクリプトを指定して起動したkyototycoonサーバに対して、ktremotemgrで以下のパターンのスクリプトを動作させる。起動コマンドは以下のとおり

    $ ktserver -scr script.lua casket.kct

- ktremotemgr経由でcallされた関数の処理にかかった時間を、開始前のタイムスタンプと終了後のタイムスタンプから計測する
- データベースの種類はよく使うTreeDB
- 計測回数は適当に5回実施して、処理時間の平均を求める
- バイナリは以下の2種類準備する。

1. kyototycoonを従来通りLuaのライブラリでビルドしたもの(以下、kyototycoon-lua)
2. kyototycoonをLuaJITライブラリでビルドしたもの(以下、kyototycoon-luajit)


## 測定パターン

1. 単純に1〜100000まで順に値を増加させたものをキーと値をsetしてそれを1〜100000まで順にgetして、最後に1〜100000まで順にremoveする

    $ ktremotemgr script test pattern order rnum 100000

2. 1.とほぼ同様であるが、値はランダム値を設定する

    $ ktremotemgr script test pattern order rnum 100000 rnd true

3. 1.のほかに、add、appendや、cursorによるiterate(逆も)処理も行う

    $ ktremotemgr script test pattern order rnum 100000 etc true

4. 1.に、2.と3.を組み合わせもの

    $ ktremotemgr script test pattern order rnum 100000 rnd true etc true

5. kyototycoonでDBに対して操作可能なadd、cas、cursorなどのオペレーションを100000回ランダムに実行する

    $ ktremotemgr script test pattern wicked rnum 100000

6. 5.を4回繰り返す

    $ ktremotemgr script test pattern wicked rnum 100000 it 4


# 測定結果
測定した結果、以下のような感じになった。単位は秒数。パターンの各番号は上記の測定パターンの番号に対応している。

## kyototycoon-lua

<table>
    <tr>
        <th></th>
        <th>測定1</th>
        <th>測定2</th>
        <th>測定3</th>
        <th>測定4</th>
        <th>測定5</th>
        <th>平均(average)</th>
    </tr>
    <tr>
        <td>パターン1</td>
        <td>1.035973072052</td>
        <td>1.0353398323059</td>
        <td>1.0413279533386</td>
        <td>1.0364339351654</td>
        <td>1.0374641418457</td>
        <td>1.0373077869415</td>
    </tr>
    <tr>
        <td>パターン2</td>
        <td>1.732880115509</td> 
        <td>1.6214940547943</td>  
        <td>1.619439125061</td> 
        <td>1.605623960495</td> 
        <td>1.6258180141449</td>  
        <td>1.6410510540008</td>
    </tr>
    <tr>
        <td>パターン3</td>
        <td>3.2687039375305</td>  
        <td>3.2817411422729</td>
        <td>3.2501521110535</td>
        <td>3.2692341804504</td>
        <td>3.2874970436096</td>
        <td>3.2714656829834</td>
    </tr>
    <tr>
        <td>パターン4</td>
        <td>4.0762410163879</td>  
        <td>4.0527050495148</td>
        <td>4.0184450149536</td>
        <td>4.025829076767</td> 
        <td>5.1436619758606</td>  
        <td>4.2633764266968</td>
    </tr>
    <tr>
        <td>パターン5</td>
        <td>0.00028181076049805</td>  
        <td>0.00028491020202637</td>  
        <td>0.00034809112548828</td>  
        <td>0.00025296211242676</td>  
        <td>0.00027990341186523</td>  
        <td>0.00028953552246094</td>
    </tr>
    <tr>
        <td>パターン6</td>
        <td>5.4520628452301</td> 
        <td>5.4013509750366</td>  
        <td>5.6718051433563</td>  
        <td>5.5400011539459</td>  
        <td>5.2509472370148</td>  
        <td>5.4632334709167</td>
    </tr>
</table>


## kyototycoon-luajit

<table>
    <tr>
        <th></th>
        <th>測定1</th>
        <th>測定2</th>
        <th>測定3</th>
        <th>測定4</th>
        <th>測定5</th>
        <th>平均(average)</th>
    </tr>
    <tr>
        <td>パターン1</td>
        <td>0.887531042099</td> 
        <td>0.92403292655945</td>   
        <td>0.88371014595032</td>   
        <td>0.934326171875</td>
        <td>0.89217805862427</td>  
        <td>0.90435566902161</td>
    </tr>
    <tr>
        <td>パターン2</td>
        <td>1.177227973938</td>  
        <td>1.1317908763885</td>    
        <td>1.1317908763885</td>    
        <td>1.127002954483</td> 
        <td>1.1521508693695</td>  
        <td>1.1439927101135</td>
    </tr>
    <tr>
        <td>パターン3</td>
        <td>2.3297441005707</td>  
        <td>2.3199369907379</td>    
        <td>2.3286230564117</td>    
        <td>2.325532913208</td> 
        <td>2.3302879333496</td>  
        <td>2.3268249988556</td>
    </tr>
    <tr>
        <td>パターン4</td>
        <td>2.7355160713196</td>  
        <td>2.7829239368439</td>    
        <td>2.7630870342255</td>    
        <td>2.7594540119171</td> 
        <td>2.7842228412628</td>  
        <td>2.7650407791138</td>
    </tr>
    <tr>
        <td>パターン5</td>
        <td>0.00058102607727051</td>  
        <td>0.00024580955505371</td> 
        <td>0.00028109550476074</td>  
        <td>0.00028109550476074</td>  
        <td>0.00024914741516113</td>  
        <td>0.00032763481140137</td>
    </tr>
    <tr>
        <td>パターン6</td>
        <td>4.1627111434937</td>  
        <td>3.8697030544281</td>  
        <td>4.0944159030914</td>  
        <td>4.44850897789</td>
        <td>4.7952580451965</td>  
        <td>4.2741194248199</td>
    </tr>
</table>

## 考察
うーん、やっぱり速いなあ。LuaJIT。パターン5のように処理量が少ないときは、LuaもLuaJITもほとんど変わらないけど、パターン6のように処理量が多いと、1秒以上も差が出てくる感じ。DBのような扱うデータ量が多いものにも恩恵を受けますなあ。


# まとめ
kyototycoonでLuaJITでパフォーマンスが向上できるかどうか検証してみた結果、性能向上が見込めることがわかりました。前回の検証と今回の検証により、kyoto系のプロダクトにおいて、LuaJITにスイッチした方が性能見込めそうです。


# ソース
いつもどおり、githubにおいておきました。

- [測定に使ったスクリプト][6]
- [kyototycoon][7]


[1]: http://blog.kazupon.jp/post/23931309864/kyotocabinet-lua-luajit
[2]: http://fallabs.com/kyototycoon/
[3]: http://luajit.org/download.html
[4]: http://fallabs.com/kyototycoon/pkg/
[5]: http://fallabs.com/kyototycoon/pkg/kyototycoon-0.9.56.tar.gz
[6]: https://gist.github.com/2821950
[7]: https://github.com/kazupon/kyototycoon
