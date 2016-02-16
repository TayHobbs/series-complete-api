class UserController < ApplicationController
  def index
    return render json: {'x' => 'This is me'}
  end
end
