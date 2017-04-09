# Handsaw-Demo

Handsawは現在開発中の軽量マークアップ言語で、以下のような特徴を持っています。

1. markdownとslimに影響を受けたシンタックス
2. Rubyでの実装
3. 独自の記法を容易に定義可能

以下のデモサイトで、基本的な変換ルールを確認することができます。

[Handsaw-Demo](https://ancient-anchorage-59376.herokuapp.com/)

## インデントの展開

基本的に`word:`の形式でインデントされるものは、class付きのdivとして展開される。`word:`形式でインデントされた内側の要素は、基本的にはMarkdownと同様に展開される。

```md:変換前
checkpoint:
  title:
    タイトル
  description
    説明文
  list:
    - 項目1
    - 項目2
```

```html:変換後
<div class="checkpoint">
  <div class="title">
    <p>タイトル</p>
  </div>
  <div class="description">
    <p>説明文</p>
  </div>
  <div class="list">
    <ul>
      <li>項目1</li>
      <li>項目2</li>
    </ul>
  </div>
</div>
```

## インライン要素の展開

`{classname: テキスト}`の形式はspanタグに変換される。

例

```md:変換前
title:
  これが{red: タイトル}です

list:
  - {blue: リスト1}だよ
  - {yellow: リスト2}だよ
```

```html:変換後
<div class="title">
  <p>これが<span class="red">タイトル</span>です</p>
</div>
<div class="list">
  <ul>
    <li><span class="blue">リスト1</span>だよ</li>
    <li><span class="yellow">リスト2</span>だよ</li>
  </ul>
</div>
```

## クラス付きのリンク

`[class: リンクテキスト](URL)`の形式で、クラス付きのaタグに展開することができる。

```md
[red: リンクテキスト](URL)
```

```html:変換後
<a href="URL" class="red">リンクテキスト</a>
```

## オプションの受け渡し

`option:value`の形式で、Rails側に値を渡すことができる。

```md
checkpoint:
  title: タイトル
  list:
    - list1
    - list2
```

ここで詳細な説明は省くが、上記の例だとRails側の処理で`@title = 'タイトル'`がインスタンス変数として使用可能になるので、メソッド内でこの値を処理可能になる。

## 独自記法の定義

例として、リンクとコメントのついた画像要素を定義する。

以下のような記法を作成する場合を考える。

```md:変換前
image:
  path: 画像のパス
  href: 画像についているリンク
  alt: 画像のaltテキスト
  comment:
    画像に関しての説明やコメント
```

```html:変換後
<div>
  <a href="画像のリンク">
    <img src="画像のパス" alt="画像のaltテキスト">
  </a>
  <div>
    <p>画像に関しての説明やコメント</p>
  </div>
</div>
```

この記法を定義するには、`Handsaw::Filters::IndentedParagraph`を継承した`Image`クラスを作成する。

```rb:image.rb
class Image < Handsaw::Filters::IndentedParagraph
end
```

そして、`Image`クラスの定義ファイルと同じ階層に`templates`フォルダを作成し、その中に`image.html.erb`ファイルを作成して変換後のhtmlを書くことになる。

```html:templates:imge.html.erb
<div>
  <%= link_to(@href) do %>
    <%= image_tag(@path, alt: @alt) %>
  <% end %>
  @value
</div>
```

`option: value`の形式を用いることで、Ruby側にインスタンス変数として値を渡すことができる。インデントされたブロックの中で、さらにインデントしてブロックを作成した場合、そのブロック以下の要素は`@value`としてまとめて取得する。上記の例だと、`comment:`以下の部分がhtmlに変換された上で`@value`に代入される。

# 目次要素

`# title`形式の見出しは、全て目次に表示される。目次に表示しない見出しを作成する場合は、`#: title`の形式を用いる。`# title`と`#: title`形式は、目次へ表示されるかの有無以外は、基本的に同一。

サンプル

```md:変換前
# 見出し1

サンプルテキスト

#: 見出し1.5(目次に表示されない)

- list1
- list2

# 見出し2

div:
  indented text

# 見出し3
```

```html:変換後
<div class="table_contents">
  <p class="table_contents_heading">目次</p>
  <div class="table_contents_inner">
    <ul>
      <li><a href="#head-1"><strong>見出し1</strong></a></li>
      <li><a href="#head-2"><strong>見出し2</strong></a></li>
      <li><a href="#head-3"><strong>見出し3</strong></a></li>
    </ul>
  </div>
</div>
<h2 class="heading" id="head-1">見出し1</h2>
<p class="text">サンプルテキスト</p>
<h2 class="heading">見出し1.5(目次に表示されない)</h2>
<ul>
  <li>list1</li>
  <li>list2</li>
</ul>
<h2 class="heading" id="head-2">見出し2</h2>
<div class="div">
  <p class="text">indented text</p>
</div>
<h2 class="heading" id="head-3">見出し3</h2>
```

# 改行

```md
{br}
```

## 注意点

インデント表現の`word:`形式の文字を、他の形式の文字と同じ階層に書いてはいけない。

これはアウト

```md:ダメな例
topclass:
  text:
  sample text
    list:
  - list1
  - list2
```

通常のマークダウンでも同様だが、複数のHTML要素を改行なしで並べても正常に展開できない。

```md:ダメな例
topclass:
  sample text
  - list1
  - list2
```

オプション記法とインデント記法は同じ階層に書くことができるが、オプション記法と通常のmarkdown記法を同じ階層に書くことはできない。

```md:ダメな例
checkpoint:
  title: タイトル
  - list1
  - list2
```
