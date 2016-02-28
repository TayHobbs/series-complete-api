class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
    return render json: @users
  end

  def show
    return render json: @user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      return render json: @user, status: :created, location: @user
    else
      return render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      return render json: @user
    else
      return render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      return render(json: {'message' => 'User successfully deleted!'})
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :email, :admin, :password_digest)
    end
end
