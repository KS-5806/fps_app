class AddPostStatusToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :post_status, :string
  end
end
