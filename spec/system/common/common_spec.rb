require 'rails_helper'

RSpec.describe '共通系', type: :system do
  context 'ログイン前' do
    before do
      visit root_path
    end
    describe 'ヘッダー' do
      it 'ヘッダーが正しく表示されていること' do
        expect(page).to have_content('ログイン'), 'ヘッダーに「ログイン」というテキストが表示されていません'
      end
    end

    describe 'フッター' do
      it 'フッターが正しく表示されていること' do
        expect(page).to have_content('Copyright'), '「Copyright」というテキストが表示されていません'
      end
    end

    describe 'タイトル' do
      it 'タイトルが正しく表示されていること' do
         expect(page).to have_title("FPS Community"), 'トップページのタイトルに「FPS Community」が含まれていません。'
       end
     end
  end

  context 'ログイン後' do
    let(:user) { create(:user) }
    before do
      login_as(user)
    end
    describe 'ヘッダー' do
      it 'ヘッダーが正しく表示されていること', js: true do
        expect(page).to have_content('動画一覧'), 'ヘッダーに「動画一覧」というテキストが表示されていません'
        expect(page).to have_content('動画作成'), 'ヘッダーに「動画作成」というテキストが表示されていません'
        find('#header-profile').click
        expect(page).to have_content('プロフィール'), 'ヘッダーに「プロフィール」というテキストが表示されていません'
        expect(page).to have_content('投稿した動画'), 'ヘッダーに「投稿した動画」というテキストが表示されていません'
        expect(page).to have_content('フォロー中'), 'ヘッダーに「フォロー中」というテキストが表示されていません'
        expect(page).to have_content('フォロワー'), 'ヘッダーに「フォロワー」というテキストが表示されていません'
        expect(page).to have_content('ログアウト'), 'ヘッダーに「ログアウト」というテキストが表示されていません'
      end
    end
    describe 'タイトル' do
      it 'タイトルが正しく表示されていること' do
         expect(page).to have_title("FPS Community"), 'トップページのタイトルに「FPS Community」が含まれていません。'
       end
     end
  end
end
