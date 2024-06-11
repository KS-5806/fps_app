require 'rails_helper'

RSpec.describe '検索機能', type: :system do
  let(:user) { create(:user) }
  let(:post1) { create(:post, title: 'Webエンジニアになるには', body: '日々学習あるのみです') }
  let(:post2) { create(:post, title: 'Rails以外に必要な知識について', body: 'どんなことが必要？') }
  let(:post3) { create(:post, title: 'Web系とSIerの違いについて', body: '自分が昔いたSIerはGitすら使っていなかった...') }
  let(:post4) { create(:post, title: 'RailsとLaravel、どっちがよいか', body: '宗教戦争の話になります。その話をする必要はありません。') }

  describe '投稿動画一覧画面での検索' do
    before do
      login_as(user)
      post1
      post2
      visit posts_path
    end
    context '検索条件に該当する投稿動画がある場合' do
      describe 'タイトルでの検索機能の検証' do
        it '該当する投稿動画のみ表示されること' do
          fill_in 'q_title_or_body_cont', with: 'Web'
          click_on '検索'
          Capybara.assert_current_path("/posts", ignore_query: true)
          expect(current_path).to eq(posts_path), '投稿動画一覧でないページに遷移しています'
          expect(page).to have_content(post1.title), '投稿動画タイトルでの検索機能が正しく機能していません'
          expect(page).not_to have_content(post2.title), '投稿動画タイトルでの検索機能が正しく機能していません'
        end
      end

      describe '本文での検索機能の検証' do
        it '該当する投稿動画のみ表示されること' do
          fill_in 'q_title_or_body_cont', with: '必要'
          click_on '検索'
          Capybara.assert_current_path("/posts", ignore_query: true)
          expect(current_path).to eq(posts_path), '投稿動画一覧でないページに遷移しています'
          expect(page).to have_content(post2.title), '投稿動画内容文での検索機能が正しく機能していません'
          expect(page).not_to have_content(post1.title), '投稿動画内容文での検索機能が正しく機能していません'
        end
      end
    end

    context '検索条件に該当する投稿動画がない場合' do
      it '1件もない旨のメッセージが表示されること' do
        fill_in 'q_title_or_body_cont', with: '一件もヒットしないよ'
        click_on '検索'
        Capybara.assert_current_path("/posts", ignore_query: true)
        expect(current_path).to eq(posts_path), '投稿動画一覧でないページに遷移しています'
        expect(page).to have_content('投稿動画がありません'), '1件もヒットしない場合、「投稿動画がありません」というメッセージが表示されていません'
      end
    end
  end

  describe 'ブックマーク一覧画面での検索' do
    before do
      login_as(user)
      post1
      post2
      post3
      post4
      user.bookmarks.create(post: post1)
      user.bookmarks.create(post: post4)
      visit bookmarks_posts_path
    end
    context '検索条件に該当する投稿動画がある場合' do
      describe 'タイトルでの検索機能の検証' do
        it '該当する投稿動画のみ表示されること' do
          fill_in 'q_title_or_body_cont', with: 'Web'
          click_on '検索'
          Capybara.assert_current_path("/posts/bookmarks", ignore_query: true)
          expect(current_path).to eq(bookmarks_posts_path), 'ブックマーク一覧でないページに遷移しています'
          expect(page).to have_content(post1.title), '投稿動画タイトルでの検索機能が正しく機能していません'
          expect(page).not_to have_content(post2.title), '投稿動画タイトルでの検索機能が正しく機能していません'
          expect(page).not_to have_content(post3.title), '投稿動画タイトルでの検索機能が正しく機能していません'
          expect(page).not_to have_content(post4.title), '投稿動画タイトルでの検索機能が正しく機能していません'
        end
      end

      describe '本文での検索機能の検証' do
        it '該当する投稿動画のみ表示されること' do
          fill_in 'q_title_or_body_cont', with: '必要'
          click_on '検索'
          Capybara.assert_current_path("/posts/bookmarks", ignore_query: true)
          expect(current_path).to eq(bookmarks_posts_path), 'ブックマーク一覧でないページに遷移しています'
          expect(page).to have_content(post4.title), '投稿動画内容文での検索機能が正しく機能していません'
          expect(page).not_to have_content(post1.title), '投稿動画内容文での検索機能が正しく機能していません'
          expect(page).not_to have_content(post2.title), '投稿動画内容文での検索機能が正しく機能していません'
          expect(page).not_to have_content(post3.title), '投稿動画内容文での検索機能が正しく機能していません'
        end
      end
    end

    context '検索条件に該当する投稿動画がない場合' do
      it '1件もない旨のメッセージが表示されること' do
        visit bookmarks_posts_path
        fill_in 'q_title_or_body_cont', with: '一件もヒットしないよ'
        click_on '検索'
        Capybara.assert_current_path("/posts/bookmarks", ignore_query: true)
        expect(current_path).to eq(bookmarks_posts_path), 'ブックマーク一覧でないページに遷移しています'
        expect(page).to have_content('ブックマーク中の投稿動画がありません'), '1件もヒットしない場合、「ブックマーク中の投稿動画がありません」というメッセージが表示されていません'
      end
    end
  end
end