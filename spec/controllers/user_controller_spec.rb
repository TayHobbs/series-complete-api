require 'rails_helper'

RSpec.describe UserController, :type => :controller do
  it 'knows math' do
    get :index
    expect(response.body).to(eq('{"x": "This is me"}'))
  end

end
