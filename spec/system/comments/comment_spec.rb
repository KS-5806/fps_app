require 'rails_helper'

RSpec.describe 'コメント', type: :system do
  let(:me) { create(:user) }
  let(:post) { create(:post) }
  let!(:comment_by_me) { create(:comment, user: me, post: post) }
  let!(:comment_by_others) { create(:comment, post: post) }

  describe 'コメントのCRUD' do
    before do
      login_as(me)
      click_on('投稿動画一覧')
      within "#post-id-#{post.id}" do
        page.find_link(post.title, exact: true).click
      end
    end
    describe 'コメントの一覧' do
      it 'コメントの一覧が表示されること' do
        within '#table-comment' do
          expect(page).to have_content(comment_by_me.body), 'コメントの本文が表示されていません'
          expect(page).to have_content(comment_by_me.user.name), 'コメントの投稿者のユーザー名が表示されていません'
        end
      end
    end

    describe 'コメントの作成' do
      it 'コメントを作成できること' do
        fill_in 'コメント', with: '新規コメント'
        click_on '投稿'
        sleep(0.5)
        comment = Comment.last
        within "#comment-#{comment.id}" do
          expect(page).to have_content(me.name), '新規作成したコメントの投稿者のユーザー名が表示されていません'
          expect(page).to have_content('新規コメント'), '新規作成したコメントの本文が表示されていません'
        end
      end
      it 'コメントの作成に失敗すること' do
        expect {
          fill_in 'コメント', with: ''
          click_on '投稿'
          sleep(0.5)
        }.to change { Comment.count }.by(0), 'コメントが作成されています'
        end
    end

    describe 'コメントの削除' do
      it 'コメントを削除できること' do
        within("#comment-#{comment_by_me.id}") do
          page.accept_confirm { find('.delete-comment-link').click }
        end
        expect(page).not_to have_content(comment_by_me.body), 'コメントの削除が正しく機能していません'
      end
    end

    describe 'コメントの編集' do
      context '他人のコメントの場合' do
        it '編集ボタン・削除ボタンが表示されないこと' do
          within "#comment-#{comment_by_others.id}" do
            expect(page).not_to have_selector('.edit-comment-button'), '他人のコメントに対して編集ボタンが表示されてしまっています'
            expect(page).not_to have_selector('.delete-comment-button'), '他人のコメントに対して削除ボタンが表示されてしまっています'
          end
        end
      end
    end
  end
end
