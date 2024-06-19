class FavoritesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: post.id)
    respond_to do |format|
      if favorite.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("favorite-button-for-post-#{post.id}", partial: 'posts/favorite', locals: { post: post })
        end
      else
        format.html { redirect_to post, alert: 'Failed to favorite.' }
      end
    end
  end

  def destroy
    favorite = current_user.favorites.find_by(post_id: params[:post_id])
    post = Post.find(params[:post_id])
    respond_to do |format|
      if favorite.destroy
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("favorite-button-for-post-#{post.id}", partial: 'posts/unfavorite', locals: { post: post })
        end
      else
        format.html { redirect_to post, alert: 'Failed to unfavorite.' }
      end
    end
  end
end
