require 'rails_helper'

RSpec.describe SeriesController, type: :controller do

  describe 'GET index' do
    it 'returns single series' do
      series = Series.create!({:title => 'Lord of the Rings'})
      get :index
      body = JSON.parse(response.body)
      expect(body).to(eq({'series' => [{'id'=>series.id, 'title'=>'Lord of the Rings', 'complete'=>false, 'installments'=>[]}]}))
    end

    it 'returns many series' do
      series_one = Series.create!({:title => 'Lord of the Rings'})
      series_two = Series.create!({:title => 'Blade Runner'})
      get :index
      body = JSON.parse(response.body)
      expect(body).to(eq({'series' => [{'id'=>series_one.id, 'title'=>'Lord of the Rings', 'complete'=>false, 'installments'=>[]}, {'id'=>series_two.id, 'title'=>'Blade Runner', 'complete'=>false, 'installments'=>[]}]}))
    end

    it 'returns series complete if all installments complete' do
      series = Series.create!({:title => 'Lord of the Rings'})
      Installment.create!({:name => 'Fellowship', :complete => true, :series => series})
      get :index
      body = JSON.parse(response.body)
      expect(body['series'][0]['complete']).to(eq(true))
    end

    it 'returns series and installments' do
      series = Series.create!({:title => 'Lord of the Rings'})
      installment = Installment.create!({:name => 'Fellowship', :complete => false, :series => series})
      get :index
      body = JSON.parse(response.body)
      body['series'][0]['installments'][0].delete('created_at')
      body['series'][0]['installments'][0].delete('updated_at')
      expect(body).to(eq({'series' => [{'id'=>series.id, 'title'=>'Lord of the Rings', 'complete'=>false, 'installments'=>[{'id'=>installment.id, 'name'=>'Fellowship', 'complete'=>false, 'series_id'=>series.id}]}]}))
    end

  end

  describe 'POST create' do
    it 'creates a new series' do
      data = {:series => {:title => 'Lord of the Rings'}}
      expect {
        post :create, params: data
      }.to change(Series, :count).by(1)
    end

    it 'returns created series attributes' do
      data = {:series => {:title => 'Lord of the Rings'}}
      post :create, params: data
      body = JSON.parse(response.body)
      body['series'].delete('id')
      expect(body).to(eq({'series' => {'title'=>'Lord of the Rings', 'complete'=>false, 'installments'=>[]}}))
    end

    it 'creates series and nested installments' do
      data = {:series => {:title => 'Lord of the Rings', :installments => [{:name => 'Fellowship', :complete => false}]}}
      post :create, params: data
      body = JSON.parse(response.body)
      expect(Series.count).to eq 1
      expect(Installment.count).to eq 1
      expect(body['series']['title']).to(eq('Lord of the Rings'))
      expect(body['series']['installments'][0]['name']).to(eq('Fellowship'))
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested series' do
      series = Series.create!({:title => 'Lord of the Rings'})
      expect {
        delete :destroy, params: {:id => series.to_param}
      }.to change(Series, :count).by(-1)
    end

    it 'returns success message on success' do
      series = Series.create!({:title => 'Lord of the Rings'})
      delete :destroy, params: {:id => series.to_param}
      body = JSON.parse(response.body)
      expect(body).to(eq({'message' => 'Series successfully deleted!'}))
    end
  end
end
