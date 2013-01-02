---
state: published
tags: grunt,project,scaffold,grunt.js,build,tools
date: '2013-01-02 17:10:00 GMT'
format: markdown
slug: grunt-scratch-project
title: GruntをスクラッチなJavascriptプロジェクトに導入する
id: 39482409323
type: text
---

Javascript 向けのプロジェクトビルドツールである，[Grunt][Grunt] というものがある．今お手伝いしているプロジェクトでそろそろ scaffold 的なものが必要になってきた．なので，まずは[ここ][grunt-wiki]のドキュメントを参考にしながら，クリーンでスクラッチな Node 向けのプロジェクトに Grunt を導入してみる．その次に [grunt-init][grunt-init] で簡単な単体テストのコードのテンプレを作成できるようにしてみる．

前提
====
今回のこのブログ記事で利用する Grunt のバージョンは，現時点の 0.4.x 系バージョンを利用して進めていく．[ここ][Grunt-migration]にも書いてあるとおり，0.4.x 系では 0.3.x 系と比べると大分変わっているので，従来から Grunt を利用している方は，変更点を確認した方がいいと思う．というより，確認するべき！


Nodeバージョン
==============
今回のブログ記事で利用する Node 関連のバージョンは以下のとおり．

- node: 0.8.16
- npm: 1.1.69


grunt-cliのインストール
=======================
まずは，`npm` コマンドで `grunt-cli` をインストールする．インストールするときは，`-g` オプションありでグローバルインストールする．

    $ npm install -g grunt-cli

正常にインストールできると，コマンド `grunt` によってビルドができるようになる．スクラッチなプロジェクトなところで `grunt` コマンドを実行すると以下のようなものが出力されると思う．

    $ grunt
    grunt-cli: The grunt command line interface. (v0.1.6)

    Fatal error: Unable to find local grunt.

    If you're seeing this message, either a Gruntfile wasn't found or grunt
    hasn't been installed locally to your project. For more information about
    installing and configuring grunt, please see the Getting Started guide:
    
    http://gruntjs.com/getting-started'

なお，既に 0.3.x 系の `grunt` をインストールをしている場合は，`npm uninstall -g grunt` で一度アンインストールする必要がある．


package.jsonの作成
===================
次に `npm init` 等で package.json を作成する．自分の環境で適当にインタラクティブに入力して作成したものは以下のとおり．

    {
        "name": "foo",
        "version": "0.0.1",
        "description": "this is sample grunt project.",
        "main": "index.js",
        "scripts": {
            "test": "echo \"Error: no test specified\" && exit 1"
        },
        "repository": {
            "type": "git",
            "url": "git@gist.github.com:4428581.git"
        },
        "author": "kazupon",
        "license": "MIT",
        "gitHead": "84ae047d1da7091d2be6b7d5a4d75f82f6ca92f0"
    }


gruntのインストール
===================
続いて，`npm install`で `grunt` をインストールする．今回インストールする `gurnt` のバージョンは，とりあえず現時点で最新の 0.4.0rc4 を利用する．バージョンを指定しているのは，指定しないと 0.3.x 系の最新バージョンがインストールされるため．

具体的には以下のようなコマンドでバージョン指定でインストールする．

    $ npm install grunt@0.4.0rc4 --save-dev

`--save-dev` オプションを指定しているので，package.json の devDependencies に `grunt` を開発向けの依存モジュールとして追加してくれる．`--save-dev`，`--save` オプションは便利．自分のプロジェクトの内容に応じてこれらのオプションを適切にすればよい．

以下は，今回上記コマンド後の package.json の中身．

    {
        "name": "foo",
        "version": "0.0.1",
        "description": "this is sample grunt project.",
        "main": "index.js",
        "scripts": {
            "test": "echo \"Error: no test specified\" && exit 1"
        },
        "repository": {
            "type": "git",
            "url": "git@gist.github.com:4428581.git"
        },
        "author": "kazupon",
        "license": "MIT",
        "gitHead": "84ae047d1da7091d2be6b7d5a4d75f82f6ca92f0",
        "devDependencies": {
            "grunt": "~0.4.0rc4"
        }
    }


Gruntプラグインのインストール
=============================
Gruntプラグインのサンプルとして，`grunt-contrib-jshint`もインストールしておく．

`grunt-contrib-jshint` はその名のとおり，`jshint`をタスクとして実行できるようしてくれるプラグイン．これも `--save-dev` オプション指定した `npm install` で以下のように実行して `grunt-contrib-jshint` をインストールする．

    $ npm install grunt-contrib-jshint --save-dev

上記コマンドを実行すると，以下のような package.json の中身になる．

    {
        "name": "foo",
        "version": "0.0.1",
        "description": "this is sample grunt project.",
        "main": "index.js",
        "scripts": {
            "test": "echo \"Error: no test specified\" && exit 1"
        },
        "repository": {
            "type": "git",
            "url": "git@gist.github.com:4428581.git"
        },
        "author": "kazupon",
        "license": "MIT",
        "gitHead": "84ae047d1da7091d2be6b7d5a4d75f82f6ca92f0",
        "devDependencies": {
            "grunt": "~0.4.0rc4",
            "grunt-contrib-jshint": "~0.1.0"
        }
    }


Gruntfile.js
============
続いて，プロジェクトをビルドする際のタスクの設定・振舞いを記載する `Gruntfile.js` をファイル名として作成する．作成するファイル内容はもちろん，Javascript で書いたものとなる．

この `Gruntfile.js` にいろいろとタスクの設定・振舞いを JavaScript コードを書くことで，`grunt` コマンドがこのファイルを読み込んで，プロジェクトのタスクとして実行できるようになるというわけだ．

`grunt` コマンドが実行可能なタスク内容は，`grunt --help` で確認することができる．`Gruntfile.js` がない状態，もしくは何もタスクを登録してない状態だと以下のような出力になると思う．以下は自分の環境で `grunt --help` を実行したときの出力内容．

    $ grunt --help
    grunt: a task-based command line build tool for JavaScript projects. (v0.4.0rc4)

    Usage
     grunt [options] [task [task ...]]

    Options
        --help, -h  Display this help text.                                        
            --base  Specify an alternate base path. By default, all file paths are 
                    relative to the Gruntfile. (grunt.file.setBase) *              
        --no-color  Disable colored output.                                        
       --gruntfile  Specify an alternate Gruntfile. By default, grunt looks in the 
                    current or parent directories for the nearest Gruntfile.js or  
                    Gruntfile.coffee file.                                         
       --debug, -d  Enable debugging mode for tasks that support it.               
           --stack  Print a stack trace when exiting with a warning or fatal error.
       --force, -f  A way to force your way past warnings. Want a suggestion? Don't
                    use this option, fix your code.                                
           --tasks  Additional directory paths to scan for task and "extra" files. 
                    (grunt.loadTasks) *                                            
             --npm  Npm-installed grunt plugins to scan for task and "extra" files.
                    (grunt.loadNpmTasks) *                                         
        --no-write  Disable writing files (dry run).                               
     --verbose, -v  Verbose mode. A lot more information output.                   
     --version, -V  Print the grunt version. Combine with --verbose for more info. 
      --completion  Output shell auto-completion rules. See the grunt-cli          
                    documentation for more information.                            

    Options marked with * have methods exposed via the grunt API and should instead
    be specified inside the Gruntfile wherever possible.

    Available tasks
    (no tasks found)

    The list of available tasks may change based on tasks directories or grunt
    plugins specified in the Gruntfile or via command-line options.

    For more information, see http://gruntjs.com/

`Available tasks` はプロジェクトで利用できるタスクを示しており，今回は何もまだ `Gruntfile.js` を作ってもいないので，`no tasks found` と出力されていることがお分かりかと．

では，具体的に `Gruntfile.js` を作ってみるとどうなるか．そしてどう作るのか．今回 `grunt-contrib-jshint` というコードチェックできるプラグインを入れているので，それをタスクとして利用する場合の `Gruntfile.js` の内容は以下のようになる．

<pre class="prettyprint linenums">
'use strict';

module.exports = function (grunt) { // (1): export
  // (2): task configuration
  grunt.initConfig({
    jshint: {
      options: {
        node: true
      },
      files: {
        src: [ 'Gruntfile.js' ]
      }
    }
  });

  // (3): load plugin task(s)
  grunt.loadNpmTasks('grunt-contrib-jshint');

  // (4): register default task(s)
  grunt.registerTask('default', [ 'jshint' ]);
};
</pre>

上記の `Gruntfile.js` の内容については，[ここ][getting-started]と[ここ][configuration-task] に書いてあるのでそれを読んでもらえれば分かると思うので説明するまでものないと思うが，軽くポイントを説明すると 基本，`Gruntfile.js` には以下のようなコードを書かなければならない．

1. grunt 引数を受け取る関数をexportする
2. その関数の中で，タスクの初期設定をする
3. そんでもって，プラグインタスクがあれば，ロードし，
4. デフォルトで実行したいタスクがあれば登録する

ちなみに，上記3.は，Grunt の API `grunt.registerTask` でオレオレ的なタスクを定義する場合は，このプラグインをロードするコードを書かなくてもよい．

上記4.は，`grunt` で特にターゲット，パラメータ等を指定してないときにデフォルトでタスクを実行するようにするためもの(実はこれはalias taskと呼ばれるもの)なので，不要ならこの部分はなくてもいいが，あったほうが便利なので，この部分のコードは書いておいた方がいいと思う．

この `Gruntfile.js` がある状態で，`grunt --help` を実行すると以下のような出力になる．

    grunt: a task-based command line build tool for JavaScript projects. (v0.4.0rc4)

    Usage
     grunt [options] [task [task ...]]

    Options
        --help, -h  Display this help text.                                        
            --base  Specify an alternate base path. By default, all file paths are 
                    relative to the Gruntfile. (grunt.file.setBase) *              
        --no-color  Disable colored output.                                        
       --gruntfile  Specify an alternate Gruntfile. By default, grunt looks in the 
                    current or parent directories for the nearest Gruntfile.js or  
                    Gruntfile.coffee file.                                         
       --debug, -d  Enable debugging mode for tasks that support it.               
           --stack  Print a stack trace when exiting with a warning or fatal error.
       --force, -f  A way to force your way past warnings. Want a suggestion? Don't
                    use this option, fix your code.                                
           --tasks  Additional directory paths to scan for task and "extra" files. 
                    (grunt.loadTasks) *                                            
             --npm  Npm-installed grunt plugins to scan for task and "extra" files.
                    (grunt.loadNpmTasks) *                                         
        --no-write  Disable writing files (dry run).                               
     --verbose, -v  Verbose mode. A lot more information output.                   
     --version, -V  Print the grunt version. Combine with --verbose for more info. 
      --completion  Output shell auto-completion rules. See the grunt-cli          
                    documentation for more information.                            

    Options marked with * have methods exposed via the grunt API and should instead
    be specified inside the Gruntfile wherever possible.

    Available tasks
            jshint  Validate files with JSHint. *                                  
           default  Alias for "jshint" task.                                       

    Tasks run in the order specified. Arguments may be passed to tasks that accept
    them by using colons, like "lint:files". Tasks marked with * are "multi tasks"
    and will iterate over all sub-targets if no argument is specified.

    The list of available tasks may change based on tasks directories or grunt
    plugins specified in the Gruntfile or via command-line options.

    For more information, see http://gruntjs.com/


`Available tasks` に `jshint` と `default` がプロジェクトのビルドタスクとして登録されていることがお分かりかと思う．

で，`grunt` でビルドを実行すると以下のようになる．

    $ grunt
    Running "jshint:all" (jshint) task
    >> 1 file lint free.

    Done, without errors.

デフォルトで実行するタスクとして登録した `jshint` が実行されて，その実行結果が出力されている．ちなみにこれは，`grunt jshint` を実行したときと同じ．


まとめ
======
0.4.x 系の Grunt をスクラッチなプロジェクトに導入する手順を説明しました．`npm install` で `--save-dev`，`--save` オプションを指定して Grunt 関連のモジュールをインストールすることで，package.json に devDependencies，dependencies にそれらモジュールが自動的に追加されて，プロジェクトの関連モジュールのセットアップが楽になります．`Gruntfile.js` にタスクの設定・振舞いを Grunt の作法に従って JavaScript コードで実装することで，プロジェクトのビルドタスクとして，`grunt` コマンドで実行することが可能になりました．

scaffold については，次のブログで，grunt-init を使って導入について説明したいと思います．


コード
======
これまでのコードはいつもどおり，[gist][gist]に置いておきました．


[Grunt]: http://gruntjs.com
[grunt-wiki]: https://github.com/gruntjs/grunt/wiki
[grunt-init]: https://github.com/gruntjs/grunt-init
[getting-started]: https://github.com/gruntjs/grunt/wiki/Getting-started
[configuration-task]: https://github.com/gruntjs/grunt/wiki/Configuring-tasks
[Grunt-migration]: https://github.com/gruntjs/grunt/wiki/Upgrading-from-0.3-to-0.4
[grunt-init]: https://github.com/gruntjs/grunt-init
[gist]: https://gist.github.com/4428581
