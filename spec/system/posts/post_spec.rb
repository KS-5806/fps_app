require 'rails_helper'

RSpec.describe '投稿動画', type: :system do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }

  describe '投稿動画のCRUD' do
    describe '投稿動画の一覧' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit '/posts'
          Capybara.assert_current_path("/login", ignore_query: true)
          expect(current_path).to eq('/login'), 'ログインページにリダイレクトされていません'
          expect(page).to have_content('ログインしてください'), 'フラッシュメッセージ「ログインしてください」が表示されていません'
        end
      end

      context 'ログインしている場合' do
        it 'ヘッダーのリンクから投稿動画一覧へ遷移できること' do
          login_as(user)
          click_on('投稿動画一覧')
          Capybara.assert_current_path("/posts", ignore_query: true)
          expect(current_path).to eq('/posts'), 'ヘッダーのリンクから投稿動画一覧画面へ遷移できません'
        end

        context '投稿動画が一件もない場合' do
          it '何もない旨のメッセージが表示されること' do
            login_as(user)
            click_on('投稿動画一覧')
            expect(page).to have_content('投稿動画がありません'), '投稿動画が一件もない場合、「投稿動画がありません」というメッセージが表示されていません'
          end
        end

        context '投稿動画がある場合' do
          it '投稿動画の一覧が表示されること' do
            post
            login_as(user)
            click_on('投稿動画一覧')
            expect(page).to have_content(post.title), '投稿動画一覧画面に投稿動画のタイトルが表示されていません'
            expect(page).to have_content(post.user.name), '投稿動画一覧画面に投稿者のユーザー名が表示されていません'
            expect(page).to have_content(post.body), '投稿動画一覧画面に投稿動画の本文が表示されていません'
          end
        end
      end
    end
  end
end
