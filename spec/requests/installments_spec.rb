require 'rails_helper'

RSpec.describe "Installments", type: :request do

  before(:all) do
    @user = User.create!(email: "#{('a'..'z').to_a.shuffle[0,8].join}@test.com", password: 'sixchars', password_confirmation: 'sixchars')
  end

  before(:each) do
    post '/login', params: {user: {email: @user.email, password: 'sixchars'}}
    @token = JSON.parse(response.body)['auth_token']
  end

  describe "installment controller" do

    it 'creates a new installment' do
      series = Series.create!({:title => 'Lord of the Rings'})
      data = {:installment => {:name => 'Fellowship', :complete => false, :series_id => series.id}}
      expect {
        post "/installments", params: data, headers: {'AUTHORIZATION': @token}
      }.to change(Installment, :count).by(1)
    end

    it 'returns created series attributes' do
      series = Series.create!({:title => 'Lord of the Rings'})
      data = {:installment => {:name => 'Fellowship', :complete => false, :series_id => series.id}}
      post "/installments", params: data, headers: {'AUTHORIZATION': @token}
      body = JSON.parse(response.body)
      body['installment'].delete('id')
      expect(body).to(eq({'installment' => {'name'=>'Fellowship', 'complete'=>false, 'series_id'=>series.id}}))
    end

    it 'updates specified record' do
      series = Series.create!({:title => 'Lord of the Rings'})
      installment = Installment.create!({:name => 'Fellowship', :complete => false, :series => series})
      patch "/installments/#{installment.id}", params: {id: installment.id, installment: {:id => installment.id, :name => 'Two Towers', :complete => true}}, headers: {'AUTHORIZATION': @token}
      body = JSON.parse(response.body)
      expect(body).to(eq({'installment' => {'id'=>installment.id, 'name'=>'Two Towers', 'complete'=>true, "series_id"=>series.id}}))
    end

    it 'destroys the requested installment' do
      series = Series.create!({:title => 'Lord of the Rings'})
      installment = Installment.create!({:name => 'Fellowship', :complete => false, :series => series})
      expect {
        delete "/installments/#{installment.id}", params: {:id => installment.to_param}, headers: {'AUTHORIZATION': @token}
      }.to change(Installment, :count).by(-1)
    end

    it 'returns success message on success' do
      series = Series.create!({:title => 'Lord of the Rings'})
      installment = Installment.create!({:name => 'Fellowship', :complete => false, :series => series})
      delete "/installments/#{installment.id}", params: {:id => installment.to_param}, headers: {'AUTHORIZATION': @token}
      body = JSON.parse(response.body)
      expect(body).to(eq({'message' => 'Installment successfully deleted!'}))
    end

  end
end
