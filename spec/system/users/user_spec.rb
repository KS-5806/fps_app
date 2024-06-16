require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
  it '正しいタイトルが表示されていること' do
    visit '/users/new'
    expect(page).to have_title("ユーザー登録 | FPS Community"), 'ユーザー登録ページのタイトルに「ユーザー登録 | FPS Community」が含まれていません。'
  end

  context '入力情報正常系' do
    it 'ユーザーが新規作成できること' do
      visit '/users/new'
      expect {
        fill_in 'ユーザー名', with: 'ユーザー'
        fill_in 'メールアドレス', with: 'example@example.com'
        fill_in 'パスワード', with: '12345678'
        fill_in 'パスワード確認', with: '12345678'
        click_button '登録'
        Capybara.assert_current_path("/", ignore_query: true)
      }.to change { User.count }.by(1)
      expect(page).to have_content('ユーザー登録が完了しました'), 'フラッシュメッセージ「ユーザー登録が完了しました」が表示されていません'
    end
  end

  context '入力情報異常系' do
    it 'ユーザーが新規作成できない' do
      visit '/users/new'
      expect {
        fill_in 'メールアドレス', with: 'example@example.com'
        click_button '登録'
      }.to change { User.count }.by(0)
      expect(page).to have_content('ユーザー登録に失敗しました'), 'フラッシュメッセージ「ユーザー登録に失敗しました」が表示されていません'
      expect(page).to have_content('ユーザー名を入力してください'), 'フラッシュメッセージ「ユーザー名を入力してください」が表示されていません'
      expect(page).to have_content('パスワードは3文字以上で入力してください'), 'フラッシュメッセージ「パスワードは3文字以上で入力してください」が表示されていません'
    end
  end

  context 'ログイン後' do
    let(:user) { create(:user) }
    before { login_as(user) }

    it 'プロフィールの詳細が見られること' do
      visit posts_path
      find('#header-profile').click
      click_on 'プロフィール'
      Capybara.assert_current_path("/users/#{user.id}", ignore_query: true)
      expect(current_path).to eq("/users/#{user.id}"), 'プロフィールページに遷移していません'
      expect(page).to have_content(user.email), 'プロフィールページにメールアドレスが表示されていません'
      expect(page).to have_content(user.name), 'プロフィールページにユーザー名が表示されていません'
      expect(page).to have_content('フォロー中'), 'プロフィールページにフォロー中が表示されていません'
      expect(page).to have_content('フォロワー'), 'プロフィールページにフォロワーが表示されていません'
      expect(page).to have_content('投稿動画'), 'プロフィールページに投稿動画が表示されていません'
      expect(page).to have_content('質問動画'), 'プロフィールページに質問動画が表示されていません'
      expect(page).to have_content('コメントした動画'), 'プロフィールページにコメントした動画が表示されていません'
    end

    it 'プロフィールの編集ができること' do
      visit posts_path
      find('#header-profile').click
      click_on 'プロフィール'
      click_on '編集'
      Capybara.assert_current_path("/users/#{user.id}/edit", ignore_query: true)
      expect(current_path).to eq("/users/#{user.id}/edit"), 'プロフィール編集ページに遷移していません'
      file_path = Rails.root.join('spec', 'fixtures', 'example.jpg')
      attach_file('プロフィール画像', file_path)
      fill_in 'メールアドレス', with: 'edit@example.com'
      fill_in 'ユーザー名', with: 'ユーザー'
      fill_in '自己紹介文', with: '編集後自己紹介文の内容'
      click_button '更新'
      Capybara.assert_current_path("/users/#{user.id}", ignore_query: true)
      expect(current_path).to eq("/users/#{user.id}"), 'プロフィールページに遷移していません'
      expect(page).to have_content('ユーザーを更新しました'), 'フラッシュメッセージ「ユーザーを更新しました」が表示されていません'
      expect(page).to have_selector("img[src$='example.jpg']"), '更新後のアバターが表示されていません'
      expect(page).to have_content('edit@example.com'), '更新後のメールアドレスが表示されていません'
      expect(page).to have_content('ユーザー'), '更新後のユーザー名が表示されていません'
      expect(page).to have_content('編集後自己紹介文の内容'), '更新後の自己紹介文が表示されていません'
    end

    it 'プロフィールの編集に失敗すること' do
      visit posts_path
      find('#header-profile').click
      click_on 'プロフィール'
      click_on '編集'
      Capybara.assert_current_path("/users/#{user.id}/edit", ignore_query: true)
      expect(current_path).to eq("/users/#{user.id}/edit"), 'プロフィール編集ページに遷移していません'
      fill_in 'メールアドレス', with: ''
      fill_in 'ユーザー名', with: ''
      click_button '更新'
      expect(page).to have_content('ユーザーを更新出来ませんでした'), 'フラッシュメッセージ「ユーザーを更新出来ませんでした」が表示されていません'
      expect(page).to have_content('メールアドレスを入力してください'), 'エラーメッセージ「メールアドレスを入力してください」が表示されていません'
      expect(page).to have_content('ユーザー名を入力してください'), 'エラーメッセージ「ユーザー名を入力してください」が表示されていません'
    end
  end
end
