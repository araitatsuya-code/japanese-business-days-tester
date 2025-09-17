# 日本営業日チェッカー

日本の営業日（平日・祝日を考慮）を簡単にチェックできるWebアプリケーションです。

## 機能

- 📅 日付を選択して営業日かどうかを判定
- 🇯🇵 日本の祝日に対応
- 🌐 日本語インターフェース
- ⚡ リアルタイム入力検証
- 📱 レスポンシブデザイン

## 必要な環境

- Ruby 3.0以上
- Bundler

## インストール

1. リポジトリをクローン
```bash
git clone <repository-url>
cd japanese-business-days-tester
```

2. 依存関係をインストール
```bash
bundle install
```

## 使用方法

### アプリケーションの起動

```bash
ruby app.rb
```

アプリケーションは `http://localhost:4567` で起動します。

### 使い方

1. ブラウザで `http://localhost:4567` にアクセス
2. カレンダーから日付を選択
3. 「営業日をチェック」ボタンをクリック
4. 結果を確認

## API エンドポイント

### メインページ
- `GET /` - 日付入力フォーム

### 営業日チェック
- `POST /check` - 日付を送信して営業日判定

### ヘルスチェック
- `GET /health` - アプリケーションとgemの状態確認（JSON形式）
- `GET /status` - シンプルなステータス確認

## 技術仕様

- **フレームワーク**: Sinatra
- **テンプレートエンジン**: ERB
- **スタイリング**: Bootstrap 5
- **営業日判定**: japanese_business_days gem
- **フロントエンド**: Vanilla JavaScript

## プロジェクト構造

```
japanese-business-days-tester/
├── app.rb              # メインアプリケーション
├── Gemfile             # 依存関係定義
├── views/              # ERBテンプレート
│   ├── layout.erb      # レイアウトテンプレート
│   ├── index.erb       # メインページ
│   └── result.erb      # 結果表示ページ
└── public/             # 静的ファイル
    ├── css/
    │   └── style.css   # カスタムスタイル
    └── js/
        └── app.js      # JavaScript機能
```

## エラーハンドリング

アプリケーションは以下のエラーを適切に処理します：

- 無効な日付形式
- 空の入力
- 日付範囲外（1900年〜2035年）
- japanese_business_days gemが利用できない場合
- システムエラー

## 開発

### テスト実行

現在、基本的な機能テストが実装されています。アプリケーションを起動して手動でテストしてください。

### 貢献

1. フォークしてください
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 依存関係

- [Sinatra](https://sinatrarb.com/) - Webアプリケーションフレームワーク
- [japanese_business_days](https://github.com/culturecode/japanese_business_days) - 日本の営業日判定gem
- [Bootstrap](https://getbootstrap.com/) - CSSフレームワーク