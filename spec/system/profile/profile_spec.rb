require 'rails_helper'

RSpec.describe 'プロフィール', type: :system do
  let(:user) { create(:user) }
  before { login_as(user) }

  it 'プロフィールの詳細が見られること' do
    visit posts_path
    find('#header-profile').click
    click_on 'プロフィール'
    Capybara.assert_current_path("/profile", ignore_query: true)
    expect(current_path).to eq(profile_path), 'プロフィールページに遷移していません'
    expect(page).to have_content(user.email), 'プロフィールページにメールアドレスが表示されていません'
    expect(page).to have_content(user.name), 'プロフィールページにユーザー名が表示されていません'
    expect(page).to have_content('フォロー中'), 'プロフィールページにフォロー中が表示されていません'
    expect(page).to have_content('フォロワー'), 'プロフィールページにフォロワーが表示されていません'
  end

  it 'プロフィールの編集ができること' do
    visit profile_path
    click_on '編集'
    Capybara.assert_current_path("/profile/edit", ignore_query: true)
    expect(current_path).to eq(edit_profile_path), 'プロフィール編集ページに遷移していません'
    file_path = Rails.root.join('spec', 'fixtures', 'example.jpg')
    attach_file('プロフィール画像', file_path)
    fill_in 'メールアドレス', with: 'edit@example.com'
    fill_in 'ユーザー名', with: 'ユーザー'
    fill_in '自己紹介文', with: '編集後自己紹介文の内容'
    click_button '更新'
    Capybara.assert_current_path("/profile", ignore_query: true)
    expect(current_path).to eq(profile_path), 'プロフィールページに遷移していません'
    expect(page).to have_content('ユーザーを更新しました'), 'フラッシュメッセージ「ユーザーを更新しました」が表示されていません'
    expect(page).to have_selector("img[src$='example.jpg']"), '更新後のアバターが表示されていません'
    expect(page).to have_content('edit@example.com'), '更新後のメールアドレスが表示されていません'
    expect(page).to have_content('ユーザー'), '更新後のユーザー名が表示されていません'
    expect(page).to have_content('編集後自己紹介文の内容'), '更新後の自己紹介文が表示されていません'
  end

  it 'プロフィールの編集に失敗すること' do
    visit profile_path
    click_on '編集'
    Capybara.assert_current_path("/profile/edit", ignore_query: true)
    expect(current_path).to eq(edit_profile_path), 'プロフィール編集ページに遷移していません'
    fill_in 'メールアドレス', with: ''
    fill_in 'ユーザー名', with: ''
    click_button '更新'
    expect(page).to have_content('ユーザーを更新出来ませんでした'), 'フラッシュメッセージ「ユーザーを更新出来ませんでした」が表示されていません'
    expect(page).to have_content('メールアドレスを入力してください'), 'エラーメッセージ「メールアドレスを入力してください」が表示されていません'
    expect(page).to have_content('ユーザー名を入力してください'), 'エラーメッセージ「ユーザー名を入力してください」が表示されていません'
  end
end