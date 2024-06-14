class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def show
    @my_posts = current_user.posts.all.order(created_at: :desc).page(params[:page])
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path, success: t('defaults.message.profile_updated', item: User.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.profile_not_updated', item: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :avatar, :avatar_cache)
  end
end
