require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'reset_password_email' do
    let(:user) { create :user }
    let(:mail) { UserMailer.reset_password_email(user) }
    before { user.generate_reset_password_token! }

    it 'ヘッダー情報・ボディ情報が正しいこと' do
      expect do
        mail.deliver_now
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(mail.subject).to eq('パスワードリセット'), 'パスワードリセットメールの件名は「パスワードリセット」にしてください'
      expect(mail.to).to eq([user.email]), 'パスワードリセットメールの宛先は適切なユーザーに設定してください'
      expect(mail.from).to eq(['from@example.com']), 'パスワードリセットメールの送信元はfrom@example.comに設定してください'
    end
  end
end
