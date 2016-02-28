require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  let(:valid_attributes) {
    {:username => 'Michael', :email => 'test@test.com', :password_digest => 'asdf'}
  }

  describe 'GET index' do
    it 'assigns all users as @users' do
      user = User.create! valid_attributes
      get :index
      expect(JSON.parse(response.body)).to eq({'users' => [user.as_json(except: ['created_at', 'updated_at', 'password_digest'])]})
    end
  end

  describe 'GET show' do
    it 'assigns the requested user as @user' do
      user = User.create! valid_attributes
      get :show, params: {:id => user.to_param}
      body = JSON.parse(response.body)
      expect(body).to eq({'user' => user.as_json(except: ['created_at', 'updated_at', 'password_digest'])})
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new User' do
        expect {
          post :create, params: {:user => valid_attributes}
        }.to change(User, :count).by(1)
      end

      it 'returns created users attributes' do
        post :create, params: {:user => valid_attributes}
        body = JSON.parse(response.body)
        expect(body).to(eq({'user' => {'id'=>1, 'username'=>'Michael', 'email'=>'test@test.com', 'admin'=>'f'}}))
      end
    end
  end

  describe 'PUT update' do
    it 'updates the user and returns updated user info on success' do
      user = User.create! valid_attributes
      put :update, params: {:id => user.to_param, :user => {:username => 'Michelle'}}
      expect(JSON.parse(response.body)).to(eq({'user' => {'id'=>1, 'username'=>'Michelle', 'email'=>'test@test.com', 'admin'=>'f'}}))
    end

    it 'does not update the user and returns error message on error' do
      user = User.create! valid_attributes
      put :update, params: {:id => user.to_param, :user => {:email => 'test2test.com'}}
      expect(JSON.parse(response.body)).to(eq('email' => ['is invalid']))
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested user' do
      user = User.create!(valid_attributes)
      expect {
        delete :destroy, params: {:id => user.to_param}
      }.to change(User, :count).by(-1)
    end

    it 'returns success message on success' do
      user = User.create!(valid_attributes)
      delete :destroy, params: {:id => user.to_param}
      body = JSON.parse(response.body)
      expect(body).to(eq({'message' => 'User successfully deleted!'}))
    end
  end

end
