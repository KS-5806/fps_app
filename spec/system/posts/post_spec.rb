require 'rails_helper'

RSpec.describe '投稿動画', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
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

        it '正しいタイトルが表示されていること' do
          login_as(user)
          click_on('投稿動画一覧')
          expect(page).to have_title("投稿動画一覧 | FPS Community"), '投稿動画一覧ページのタイトルに「投稿動画一覧 | FPS Community」が含まれていません。'
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
    describe '投稿動画の詳細' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit post_path(post)
          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインしてください'
        end
      end

      context 'ログインしている場合' do
        before do
          post
          login_as(user)
        end
        it '投稿動画の詳細が表示されること' do
          click_on('投稿動画一覧')
          within "#post-id-#{post.id}" do
            page.find_link(post.title, exact: true).click
          end
          Capybara.assert_current_path("/posts/#{post.id}", ignore_query: true)
          expect(current_path).to eq("/posts/#{post.id}"), '掲示板のタイトルリンクから掲示板詳細画面へ遷移できません'
          expect(page).to have_content post.title
          expect(page).to have_content post.user.name
          expect(page).to have_content post.body
        end
        it '正しいタイトルが表示されていること' do
          click_on('投稿動画一覧')
          within "#post-id-#{post.id}" do
            page.find_link(post.title, exact: true).click
          end
          expect(page).to have_title("#{post.title} | FPS Community"), '動画詳細ページのタイトルに動画のタイトルが含まれていません。'
        end
      end
    end
    describe '動画の作成' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit '/posts/new'
          Capybara.assert_current_path("/login", ignore_query: true)
          expect(current_path).to eq('/login'), 'ログインしていない場合、動画作成画面にアクセスした際に、ログインページにリダイレクトされていません'
          expect(page).to have_content('ログインしてください'), 'フラッシュメッセージ「ログインしてください」が表示されていません'
        end
      end

      context 'ログインしている場合' do
        before do
          login_as(user)
          click_on('動画作成')
        end

        it '正しいタイトルが表示されていること' do
          expect(page).to have_title("動画作成 | FPS Community"), '動画作成ページのタイトルに「動画作成 | FPS Community」が含まれていません。'
        end

        it '動画が作成できること' do
          fill_in 'タイトル', with: 'テストタイトル'
          fill_in '内容', with: 'テスト内容'
          file_path = Rails.root.join('spec', 'fixtures', 'sample_movie.mp4')
          attach_file "動画", file_path
          click_button '登録'
          Capybara.assert_current_path("/posts", ignore_query: true)
          expect(current_path).to eq('/posts'), '動画一覧画面に遷移していません'
          expect(page).to have_content('動画を作成しました'), 'フラッシュメッセージ「動画を作成しました」が表示されていません'
          expect(page).to have_content('テストタイトル'), '作成した動画のタイトルが表示されていません'
          expect(page).to have_content('テスト内容'), '作成した動画の内容が表示されていません'
        end

        it '動画の作成に失敗すること' do
          fill_in 'タイトル', with: 'テストタイトル'
          file_path = Rails.root.join('spec', 'fixtures', 'sample_movie.mp4')
          attach_file "動画", file_path
          click_button '登録'
          expect(page).to have_content('動画を作成出来ませんでした'), 'フラッシュメッセージ「動画を作成出来ませんでした」が表示されていません'
          expect(page).to have_content('内容を入力してください'), 'エラーメッセージ「内容を入力してください」が表示されていません'
        end
      end
    end

    describe '投稿動画の更新' do
      before { post }
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit edit_post_path(post)
          expect(current_path).to eq('/login'), 'ログインページにリダイレクトされていません'
          expect(page).to have_content 'ログインしてください'
        end
      end

      context 'ログインしている場合' do
        context '自分の投稿動画' do
          before do
            login_as(user)
            visit posts_path
            find("#button-edit-#{post.id}").click
          end
          it '投稿動画が更新できること' do
            fill_in 'タイトル', with: '編集後テストタイトル'
            fill_in '内容', with: '編集後テスト内容'
            click_button '更新'
            Capybara.assert_current_path("/posts/#{post.id}", ignore_query: true)
            expect(current_path).to eq post_path(post)
            expect(page).to have_content('投稿動画を更新しました'), 'フラッシュメッセージ「投稿動画を更新しました」が表示されていません'
            expect(page).to have_content('編集後テストタイトル'), '更新後のタイトルが表示されていません'
            expect(page).to have_content('編集後テスト内容'), '更新後の内容が表示されていません'
          end

          it '投稿動画の作成に失敗すること' do
            fill_in 'タイトル', with: '編集後テストタイトル'
            fill_in '内容', with: ''
            click_button '更新'
            expect(page).to have_content('投稿動画を更新出来ませんでした'), 'フラッシュメッセージ「投稿動画を更新出来ませんでした」が表示されていません'
          end
        end

        context '他人の投稿動画' do
          it '編集ボタンが表示されないこと' do
            login_as(another_user)
            visit posts_path
            expect(page).not_to have_selector("#button-edit-#{post.id}"), '他人の投稿動画に対して編集ボタンが表示されています'
          end
        end
      end
    end

    describe '投稿動画の削除' do
      before { post }
      context '自分の投稿動画' do
        it '投稿動画が削除できること', js: true do
          login_as(user)
          visit '/posts'
          page.accept_confirm { find("#button-delete-#{post.id}").click }
          expect(current_path).to eq('/posts'), '投稿動画削除後に、投稿動画の一覧ページに遷移していません'
          expect(page).to have_content('投稿動画を削除しました'), 'フラッシュメッセージ「投稿動画を削除しました」が表示されていません'
        end
      end

      context '他人の投稿動画' do
        it '削除ボタンが表示されないこと' do
          login_as(another_user)
          visit posts_path
          expect(page).not_to have_selector("#button-delete-#{post.id}"), '他人の投稿動画に対して削除ボタンが表示されています'
        end
      end
    end
    describe '動画のブックマーク一覧' do
      before { post }
      context '1件もブックマークしていない場合' do
        it '1件もない旨のメッセージが表示されること' do
          login_as(user)
          visit posts_path
          find('#header-profile').click
          click_on 'ブックマーク一覧'
          Capybara.assert_current_path("/posts/bookmarks", ignore_query: true)
          expect(current_path).to eq(bookmarks_posts_path), '課題で指定した形式のリンク先に遷移させてください'
          expect(page).to have_content('ブックマーク中の動画がありません'), 'ブックマーク中の動画が一件もない場合、「ブックマーク中の動画がありません」というメッセージが表示されていません'
        end
      end

      context 'ブックマークしている場合' do
        it 'ブックマークした動画が表示されること' do
          login_as(another_user)
          visit posts_path
          find("#bookmark-button-for-post-#{post.id}").click
          find('#header-profile').click
          click_on 'ブックマーク一覧'
          Capybara.assert_current_path("/posts/bookmarks", ignore_query: true)
          expect(current_path).to eq(bookmarks_posts_path), '課題で指定した形式のリンク先に遷移させてください'
          expect(page).to have_content post.title
        end
      end
    end
  end
end
