require 'rails_helper'

describe "Post", type: :request do
  let!(:user) { create(:user) }
  let!(:new_post) { create(:post) }
  before { login_user(user, '12345678', login_path) }

  it '他人の投稿動画の編集画面に遷移できないこと' do
    expect { get edit_post_path(new_post) }.to raise_error ActiveRecord::RecordNotFound
  end

  it '他人の投稿動画を更新できないこと' do
    expect { patch post_path(new_post) }.to raise_error ActiveRecord::RecordNotFound
  end

  it '他人の投稿動画を削除できないこと' do
    expect { delete post_path(new_post) }.to raise_error ActiveRecord::RecordNotFound
  end
end
