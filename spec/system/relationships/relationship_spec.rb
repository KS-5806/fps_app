require 'rails_helper'

RSpec.describe "Relationships", type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
  end
  let(:post) { create(:post, user: @user2) }

  describe '#create,#destroy' do
    it 'ユーザーをフォロー、フォロー解除できる' do 
      # @user1としてログイン           
      login_as(@user1)

      # @user1として一覧ページへ遷移する
      click_on('投稿動画一覧')
      within "#post-id-#{post.id}" do
        page.find_link(post.user.name, exact: true).click
      end

      # @user2をフォローする
      find_link('フォローする').click
      expect(@user2.followers.count).to eq(1)
      expect(@user2.followings.count).to eq(0)

      # @user2をフォロー解除する
      find_link('フォロー外す').click
      expect(@user2.followers.count).to eq(0)
      expect(@user2.followings.count).to eq(0)
    end
  end
end