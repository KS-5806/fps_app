# サービス概要
FPSゲームをプレイするユーザーに向けた動画投稿SNSアプリです。自身のプレイ動画を投稿し、他の人からアドバイスや意見をもらったり、他の人が投稿したゲームプレイや戦術に関する動画を参考にすることができます。
# このサービスへの思い・作りたい理由
自分自身が友達とFPSゲームをプレイすることがあり、プレイ後には友達と自分達のプレイ内容についての反省会を行うことが多々あります。そういう時に、自分達のプレイ動画だけではなく他の人のプレイ動画も観たり、自分達以外の人の意見も聞いてみたいと思うことがあったので、動画投稿SNSアプリを作りたいと思いました。
# ユーザー層
ユーザー層：FPSゲームをプレイする人
作成するサービスがFPSゲームをプレイする人に向けたサービスになるので、ユーザー層はFPSゲームをプレイする人としました。
# サービスの利用イメージ
- ユーザーが、自身の動画とその動画に関するタイトルと内容文（良かったこと、聞きたいこと等）を投稿することで、他のユーザーからコメントや意見がもらえる。
他のユーザーが投稿した動画を見て、自分がプレイする時の参考にしたり、コメントや意見を投稿することができる。
- 参考になる動画や自分が気になる動画に「いいね」することができる。
- ユーザーをフォローしたり、動画のブックマーク登録することができ、いつでもすぐに見られるようにできる。
# ユーザーの獲得について
QiitaやXなどで発信してみる。一緒にゲームする友人がいるので、友人に紹介してみる。
# サービスの差別化ポイント・推しポイント
youtubeやmildomなど動画投稿ができるサービスはあるが、FPSゲームというジャンルに特化した動画投稿サービスであること。特定のジャンルに絞ることで、同じジャンルのゲームをプレイするユーザーが集まりやすくなると考えます。また、スーパープレイ動画だけでなく、自分が普段プレイしていて「この場面ではどうすれば良かったのか」と思うプレイ動画を投稿することで、ユーザー同士の意見交換ができます。
# 機能候補
## MVP
- キーワードやタグ等での検索・一覧表示機能
- 会員登録・ログイン機能
- プロフィール機能
- 動画投稿機能
- 投稿詳細機能
- いいね機能
- コメント機能
- フォロー・ブックマーク機能
## その後の機能
- マルチ検索・オートコンプリート機能
- 通知機能
- DM機能
# 機能の実装方針予定
- 通知機能：  
自分が投稿した動画にコメントが投稿された際やフォローしたユーザーが動画を投稿した際、他のユーザーからDMが送られてきた際の通知
- DM機能：  
ユーザー同士が互いにメッセージを送り合えるようにするためのDM機能
# 使用技術
- Ruby on Rails
- Ruby
- JavaScript
- RSpec