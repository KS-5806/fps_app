class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :set_user, only: %i[edit update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.order(created_at: :desc).page(params[:page])
    @question_posts = @user.posts.where(post_status: '質問動画').order(created_at: :desc).page(params[:page])
    @q = current_user.bookmark_posts.ransack(params[:q])
    @bookmark_posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, success: t('users.create.success')
    else
      flash.now[:danger] = t('users.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path, success: t('defaults.message.profile_updated', item: User.model_name.human)
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
    params.require(:user).permit(:name, :email, :introduction, :password, :password_confirmation, :avatar, :avatar_cache)
  end
end
