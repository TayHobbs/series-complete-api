require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do

  describe 'POST login' do
    it 'successfully logins created user' do
      user = User.create!(email: "#{('a'..'z').to_a.shuffle[0,8].join}@test.com", password: 'sixchars', password_confirmation: 'sixchars')
      post :login, params: {user: {email: user.email, password: 'sixchars'}}
      body = JSON.parse(response.body)
      expect(body).to(have_key('auth_token'))
      expect(body['user']).to(eq({'id'=>user.id, 'email'=>user.email}))
    end

    it 'returns error for incorrect credentials' do
      User.create!(email: "#{('a'..'z').to_a.shuffle[0,8].join}@test.com", password: 'sixchars', password_confirmation: 'sixchars')
      post :login, params: {user: {email: 'x@y.com', password: 'badpas'}}
      body = JSON.parse(response.body)
      expect(body).to(eq({'errors'=>['Invalid Username or Password']}))
    end

    it 'does not explode if user does not exist' do
      post :login, params: {user: {email: 'x@y.com', password: 'badpas'}}
      body = JSON.parse(response.body)
      expect(body).to(eq({'errors'=>['Invalid Username or Password']}))
    end

  end

end
