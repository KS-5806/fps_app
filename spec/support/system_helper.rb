module SystemHelper
  def login_as_general
    general_user = create(:user)
    visit root_path
    click_link "ログイン"
    fill_in 'Email', with: general_user.email
    fill_in 'Password', with: '12345678'
    click_button 'ログイン'
  end
end

RSpec.configure do |config|
  config.include SystemHelper
end
