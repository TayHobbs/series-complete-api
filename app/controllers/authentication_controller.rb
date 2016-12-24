class AuthenticationController < ApplicationController
  def login
    user = User.find_for_database_authentication(email: user_params[:email])
    if user and user.valid_password?(user_params[:password])
      render json: payload(user)
    else
      render json: {errors: ['Invalid Username or Password']}, status: :unauthorized
    end
  end

  private

  def payload(user)
    return nil unless user and user.id
    {
      auth_token: JSONWebToken.encode({user_id: user.id}),
      user: {id: user.id, email: user.email}
    }
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
