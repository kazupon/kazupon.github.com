---
state: published
tags: grunt,grunt.js,scaffold,tools,project
date: '2013-01-04 15:29:48 GMT'
format: markdown
slug: grunt-scaffold
title: grunt-initでプロジェクトにscaffoldな仕組みを導入する
id: 39659396196
type: text
---
[前回][prev-blog]のブログの続き．

前回のブログでは，Javascript なプロジェクトに scaffold 的な導入するための準備として，[Grunt][Grunt] を導入して `Gruntfile.js` でプロジェクトのビルドをタスクベースでできるようにした．

今回はいよいよ，前回のプロジェクトをベースに単体テストのテンプレートコードの生成のサンプルとして，本来の目的であった [grunt-init][grunt-init] によって，scaffold 的な仕組みを導入できるようにする．


注意事項
========

今回の説明で利用する `grunt-init` のバージョンは `0.2.0rc3` でまだ正式リリースされていません(unrelease)．なので，リリース版のときは，今回の手順・方法で動作しない可能性があるのであしからず．また，今回のブログ記事の内容が [README.md][README.md] の更新によりリンク切れ等が起こる可能性がありますのであしからず．


grunt-initのインストール
========================
今回の記事で利用する `grunt-init` はなるべく開発版の最新版を利用するために，以下のコマンドでインストールしたものを利用する．

    $ npm install -g git://github.com/gruntjs/grunt-init.git#fc210b7e5111ef542ddd7c56f38aeacef25866b9

インストールが無事完了すると，`gurnt-init` コマンドが利用できるようになる．コマンドを叩いて確認すると以下のような内容が出力される．

    $ grunt-init
    Running "init" task

    A valid init template name must be specified.

    Available templates
        commonjs  Create a commonjs module, including Nodeunit unit tests.         
       gruntfile  Create a basic Gruntfile.                                        
     gruntplugin  Create a grunt plugin, including Nodeunit unit tests.            
          jquery  Create a jQuery plugin, including QUnit unit tests.              
            node  Create a Node.js module, including Nodeunit unit tests.          

    Available templates that are either builtin to grunt-init or placed in the null
    directory may be run with "grunt-init TEMPLATE". Templates that exist in another
    location may be run with "grunt-init /path/to/TEMPLATE". A valid template
    directory must contain, at the very minimum, a template.js file.

`Available templates` のところに利用可能なテンプレートが何種類かあるのが分かるかと．今回の趣旨は，あくまでも自分で用意したテンプレートでカスタムなものを作って scaffold な仕組みをプロジェクトに導入することなので，デフォルトで利用できるテンプレートについては，今回は説明しない．どんなものかは，各自触ってみてください．


プロジェクトの構成
==================
自分でカスタムなテンプレートの導入について入る前に，今回の対象となるプロジェクト構成がどんなものか分からないと，イメージがつきにくいと思うので，Node でモジュールパッケージを作るプロジェクトを例として，簡単に説明しておく．

今回の導入の対象となるプロジェクト構成は，以下のような感じ．

    $ tree -L 1
    .
    ├── Gruntfile.js
    ├── lib
    ├── node_modules
    ├── package.json
    ├── templates
    └── test

    4 directories, 2 files

- `Gruntfile.js` : プロジェクトを `grunt` コマンドでビルドする際に必要になる，設定やタスクの振舞いが書かれた Javascript コード
- `package.json` : プロジェクト(パッケージ)のバージョン，作者，依存モジュールなどのメタ情報が記載された JSON ファイル
- `node_modules/` : `npm install` でインストールした Node モジュールディレクトリ
- `lib/` : 開発するモジュールを格納するディレクトリ
- `test/` : 開発するモジュールの単体テストコードが格納されたディレクトリ
- `templates/` : `grunt-init` コマンドで生成するテンプレートを格納するディレクトリ

とまあ，`templates` ，`Gruntfile.js` という特殊なものを除いては，至って一般的な Node モジュールを作成するシンプルなプロジェクト構成．なお，`Gruntfile.js` ，`package.json` は[前回][prev-blog]利用したものを使っている．

今回作成する scaffold の仕様としては，

- `grunt-init templates/unit` で単体テストコード作成開始すると，
- インタラクティブなプロンプトが立ち上がり，
- そのプロンプト上で，`lib/` で実装するモジュール名を指定すると
- `test/` に `module.test.js` のような単体テストコードスクリプトファイルを作成される

という，単純なものとする．

なお，予め [tape][tape] という単体テストのモジュール想定しているので，下記コマンドでインストールしておく．

    $ npm install tape --save-dev


カスタムテンプレートの作成
==========================
今回作成するテンプレートは，単体テストのコードなので，`grunt-init` のお作法に従って，`templates/` に `unit/` というものを掘ってそこにテンプレートというものを配置していく．

[お作法][grunt-custom-template]によると，カスタムなテンプレートは以下が必要らしい．

- `template.js`: `root/` にあるテンプレートに対する処理がかかれた Javascript コード
- `rename.json`: テンプレートのリネームルールの仕様が定義された JSON ファイル
- `root/`: テンプレートを格納するディレクトリ

`grunt-init` コマンドは，カスタムなテンプレートが格納されているディレクトリを `grunt-init templates/unit` のようにテンプレートとして指定することで，食ったテンプレートディレクトリにある `template.js` に書かれたロジックを動作させて，`rename.json` によるリネームルールを参考に `root/` 内にあるテンプレートたちにごにょごにょ処理して，対象となるプロジェクトにファイルを設置することで，scaffold な機能を提供するというわけだ．

今回作成したテンプレートの構成は以下のようになった．

    $ tree templates/
    templates/
    └── unit
        ├── rename.json
        ├── root
        │   └── test.js
        └── template.js

    2 directories, 3 files

それでは，1つ1つ解説していこう．

unit/root/test.js
----------------------
まずは，`unit/root/test.js` というテンプレート．具体的には，以下のような感じ．


```
'use strict';

var test = require('tape');
var {%= module_name %} = require('../lib/{%= module_name %}');

/*
 * tape little reference
 * =====================
 *
 * reference url
 * -------------
 * https://github.com/substack/tape
 * 
 * API
 * --- 
 * - test(name, cb)
 * - t.plan(n)
 * - t.end()
 * - t.fail(msg)
 * - t.pass(msg)
 * - t.skip(msg)
 * - t.ok(value, msg)
 *   Aliases: t.true, t.assert
 * - t.notOk(value, msg)
 *   Aliases: t.false, t.notok
 * - t.error(err, msg)
 *   Aliases: t.ifError, t.ifErr, t.iferror
 * - t.equal(a, b, msg)
 *   Aliases: t.equals, t.isEqual, t.is, t.strictEqual, t.strictEquals
 * - t.notEqual(a, b, msg)
 *   Aliases: t.notEqual, t.notStrictEqual, t.notStrictEquals, t.isNotEqual, t.isNot, t.not, t.doesNotEqual, t.isInequal
 * - t.deepEqual(a, b, msg)
 *   Aliases: t.deepEquals, t.isEquivalent, t.looseEqual, t.looseEquals, t.same
 * - t.notDeepEqual(a, b, msg)
 *   Aliases: t.notEquivalent, t.notDeeply, t.notSame,
 *   t.isNotDeepEqual, t.isNotDeeply, t.isNotEquivalent, t.isInequivalent
 * - t.throws(fn, expected, msg)
 * - t.doesNotThrow(fn, expected, msg)
 * - t.test(name, cb)
 * - var htest = test.createHarness()
 */

test('{%= module_name %}', function (t) {
  t.fail('should be implemnted test !!');

  t.end();
});
```

このテンプレートファイルの説明すべきポイントとしては，`{%= module_name %}` で `grunt-init` コマンドのプロンプトで指定されたモジュール名で置換するようにしている．`root/` 配下にあるテンプレートは，基本こんな感じで `{% %}` に置換したい変数名を指定したテンプレートを作成すればいいだけだ．今回この記事で扱うテンプレートは1つのファイルだけであるが，他にも `root/` には `grunt-init` に[ビルドイン][template-build-in]されているテンプレートのように，複数のテンプレートを設置することも可能．

なお，今回のテンプレートには，コメントで単体テストライブラリのリファレンス的なものをおまけも入れている．こうすることで，このプロジェクトに関わる初めての人にもユーザーフレンドリーになって，余計なドキュメントを作成する手間が省けるということだ．


unit/rename.json
----------------
続いて，`unit/rename.json`．このファイルには，`root/` 配下にあるテンプレートのリネームルールを JSON フォーマットで `{% %}` を使ったりしてルールを記述する．ファイル内容は以下な感じ．

    {
      "test.js": "test/{%= module_name %}.test.js"
    }

key には，`root/` 配下にある対象となるテンプレートファイル名，value の部分には，テンプレートの処理先のパスを指定する．`rename.json` の詳細仕様については，[ここ][renaming]に書かれている．ルールの複数指定はもちろん可能．

今回のブログ記事の例では，`root/test.js` が `grunt-init` のプロンプトで入力されたモジュール名で，プロジェクトの `test/` 配下に `module.test.js` のようなファイル名で処理されるようルールを指定している．

unit/template.js
----------------
最後に，`unit/template.js`．このファイルには，`grunt-init` コマンドを実行した際の，プロンプトの制御や，`root/` 配下にあるテンプレートたちに対する変数を設定したりなど，`gurnt-init` の [API][implement-template-logic] を利用して振舞いを書く．今回のブログ記事では以下のように書いた．

<pre class="prettyprint linenums">
'use strict';

// Basic template description.
exports.description = 'Create a unit test code file.';

// Template-specific notes to be displayed before question prompts.
exports.notes = 'Please specify the name of the module that is under lib/.';

// Any existing file or directory matching this wildcard will cause a warning.
//exports.warnOn = 'test/*.js';

// The actual init template.
exports.template = function (grunt, init, done) { // (1): exports
  init.process({}, [
    // (2):
    // Prompt for these values.
    {
      name: 'module_name',
      message: 'What is module name ?',
      default: '',
      warning: 'Should be a module name'
    }
  ], function (err, props) {
    // (3):
    // Files to copy (and process).
    var files = init.filesToCopy(props);

    // (4):
    // Actually copy (and process) files.
    init.copyAndProcess(files, props);

    // (5):
    // All done!
    done();
  });
};
</pre>

コード書いたといっても，[API][implement-template-logic] のドキュメントがまだリリース前で書きかけなせいか貧弱なので，上記コードは，`grunt-init` にあるビルドインテンプレートの `template.js` をコピってきて，今回の記事用に改変したものである．

上記コード `template.js` の実装ポイントを説明すると，

1. `grunt-init` でインポートされる `exports.template` を関数として実装
2. `init.process` を実行する際に，プロンプトの設定をして，
3. `init.process` を実行し，そのコールバックで，`init.filesToCopy` を呼び出して対象となるテンプレートのファイル情報を取得して，
4. `init.copyAndProcess` を呼び出してテンプレートのコピーなどの実際に処理をして，
5. `done` で完了を通知する

という実装をすればいいみたい．

今回の記事では，プロンプトでモジュール名を受け取るようにしているので，上記コード(2)のところでそうするようコードを書いている．プロンプトと指定された情報は，`init.process` のコールバックに `props` という第2引数で渡ってくるので，それを，`init.filesToCopy` や `init.copyAndProcess` に渡してやることで，テンプレートの内容が適切に置換処理されて，`rename.json` のルールで指定した内容でプロジェクト内にファイルが設置されるみたい．


カスタムテンプレートによるgrunt-init
====================================
では，カスタムテンプレートを作ったので，早速，`grunt-init` で動作させてみよう．

    $ grunt-init templates/unit/

コマンドにカスタムテンプレートを指定して実行すると，

    Running "init:templates/unit/" (init) task
    This task will create one or more files in the current directory, based on the
    environment and the answers to a few questions. Note that answering "?" to any
    question will show question-specific help and answering "none" to most questions
    will leave its value blank.

    "unit" template notes:
    Please specify the name of the module that is under lib/.

    Please answer the following:
    [?] What is module name ?

こんな風にプロンプトが立ち上がって，インタラクティブにモジュール名を指定できるようになっている．で，実際にモジュール名を指定して，プロンプトを終了させると，

    [?] What is module name ? add
    [?] Do you need to make any changes to the above before continuing? (y/N) 

    Writing test/add.test.js...OK

    Initialized from template "unit".

    Done, without errors.

というようになって，`test/` に `add.test.js` というファイルが設置された．ホントに設置されたかどうか確認してみると，

    $ ls test
    add.test.js

    $ cat test/add.test.js
    'use strict';

    var test = require('tape');
    var add = require('../lib/add');

    /*
     * tape little reference
     * =====================
     *
     * reference url
     * -------------
     * https://github.com/substack/tape
     * 
     * API
     * --- 
     * - test(name, cb)
     * - t.plan(n)
     * - t.end()
     * - t.fail(msg)
     * - t.pass(msg)
     * - t.skip(msg)
     * - t.ok(value, msg)
     *   Aliases: t.true, t.assert
     * - t.notOk(value, msg)
     *   Aliases: t.false, t.notok
     * - t.error(err, msg)
     *   Aliases: t.ifError, t.ifErr, t.iferror
     * - t.equal(a, b, msg)
     *   Aliases: t.equals, t.isEqual, t.is, t.strictEqual, t.strictEquals
     * - t.notEqual(a, b, msg)
     *   Aliases: t.notEqual, t.notStrictEqual, t.notStrictEquals, t.isNotEqual, t.isNot, t.not, t.doesNotEqual, t.isInequal
     * - t.deepEqual(a, b, msg)
     *   Aliases: t.deepEquals, t.isEquivalent, t.looseEqual, t.looseEquals, t.same
     * - t.notDeepEqual(a, b, msg)
     *   Aliases: t.notEquivalent, t.notDeeply, t.notSame,
     *   t.isNotDeepEqual, t.isNotDeeply, t.isNotEquivalent, t.isInequivalent
     * - t.throws(fn, expected, msg)
     * - t.doesNotThrow(fn, expected, msg)
     * - t.test(name, cb)
     * - var htest = test.createHarness()
     */

    test('add', function (t) {
      t.fail('should be implemnted test !!');

      t.end();
    });

というように，作ったカスタムテンプレートで scaffold 的なことが実現されているのが分かる．後は，生成された単体テストを実装して，好きに開発をしていけばよい．


まとめ
======
`grunt-init` で自分が作成したカスタムテンプレートでプロジェクトに scaffold 的な仕組みを導入できるよう説明しました．`grunt-init` のお作法によって適切にテンプレート構造でカスタムテンプレートを作成することで，`grunt-init path/to/template` のように指定することで，インタラクティブな入力によってプロジェクトに必要なファイルをシステマチックに作成・コピーをしてくれて，細かい手作業によるミスを減らしてくれるようになります．

今回のブログでは，カスタムテンプレートは至ってシンプルなものでしたが，`template.js` に `grunt-init`の API や，[grunt の API][grunt-api] をうまく利用すれば，ファイルの重複チェックや，プロンプト入力の validation なども実装すると，もっとよくてイケてる scaffold な機能を提供できます．

また，`grunt-init` はテンプレートベースによる scaffold 機能を提供してくれるので，特に Javascript なプロジェクトだけでなく，テキストベースの仕様書の作成といった，単調なテンプレート処理でも利用することができます．実例として，github の [enja-oss][enja-oss] というオープンソースな翻訳プロジェクトでは，実際に利用しているようです．

この `grunt-init` のような scaffold 的なものは，Ruby や Python といった他の言語でも存在しますが，まだまだバージョンが `0.5` にもなっていないためあれですが，Javascript な環境では，現時点で個人的にはこれが優れていると思います(他にあれば誰か教えてください！)．ぜひ，Javascript なプロジェクトでは導入して開発体制を効率化できればといいなと思っています．


コード
======
これまでのコードはいつもどおり，[gist][gist]に置いておきました．


[prev-blog]: http://blog.kazupon.jp/post/39482409323/grunt-scratch-project
[Grunt]: http://gruntjs.com
[grunt-init]: https://github.com/gruntjs/grunt-init
[README.md]: https://github.com/gruntjs/grunt-init/blob/master/README.md
[tape]: https://github.com/substack/tape
[grunt-custom-template]: https://github.com/gruntjs/grunt-init#custom-templates
[template-build-in]: https://github.com/gruntjs/grunt-init/tree/master/templates
[renaming]: https://github.com/gruntjs/grunt-init#renaming-or-excluding-template-files
[implement-template-logic]: https://github.com/gruntjs/grunt-init#defining-an-init-template
[grunt-api]: https://github.com/gruntjs/grunt/wiki
[enja-oss]: https://github.com/enja-oss/templates
[gist]: https://gist.github.com/4441219
