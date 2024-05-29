class AddMovieToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :movie, :string
  end
end
