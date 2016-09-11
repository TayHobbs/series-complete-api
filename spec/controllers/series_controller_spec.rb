require 'rails_helper'

RSpec.describe SeriesController, type: :controller do

  describe 'GET index' do
    describe 'returns expected' do
      it 'returns single series' do
        Series.create!({:title => 'Lord of the Rings', :complete => false})
        get :index
        body = JSON.parse(response.body)
        expect(body).to(eq({'series' => [{'id'=>1, 'title'=>'Lord of the Rings', 'complete'=>false, 'installments'=>[]}]}))
      end

      it 'returns many series' do
        Series.create!({:title => 'Lord of the Rings', :complete => false})
        Series.create!({:title => 'Blade Runner', :complete => true})
        get :index
        body = JSON.parse(response.body)
        expect(body).to(eq({'series' => [{'id'=>1, 'title'=>'Lord of the Rings', 'complete'=>false, 'installments'=>[]}, {'id'=>2, 'title'=>'Blade Runner', 'complete'=>true, 'installments'=>[]}]}))
      end

      it 'returns series and installments' do
        series = Series.create!({:title => 'Lord of the Rings', :complete => false})
        Installment.create!({:name => 'Fellowship', :complete => false, :series => series})
        get :index
        body = JSON.parse(response.body)
        body['series'][0]['installments'][0].delete('created_at')
        body['series'][0]['installments'][0].delete('updated_at')
        expect(body).to(eq({'series' => [{'id'=>1, 'title'=>'Lord of the Rings', 'complete'=>false, 'installments'=>[{'id'=>1, 'name'=>'Fellowship', 'complete'=>false, 'series_id'=>1}]}]}))
      end

    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new series' do
        data = {:series => {:title => 'Lord of the Rings', :complete => false}}
        expect {
          post :create, params: data
        }.to change(Series, :count).by(1)
      end

      it 'returns created series attributes' do
        data = {:series => {:title => 'Lord of the Rings', :complete => false}}
        post :create, params: data
        body = JSON.parse(response.body)
        expect(body).to(eq({'series' => {'id'=>1, 'title'=>'Lord of the Rings', 'complete'=>false, 'installments'=>[]}}))
      end

      it 'creates series and nested installments' do
        data = {:series => {:title => 'Lord of the Rings', :complete => false, :installments => [{:name => 'Fellowship', :complete => false}]}}
        post :create, params: data
        body = JSON.parse(response.body)
        expect(Series.count).to eq 1
        expect(Installment.count).to eq 1
        expect(body['series']['title']).to(eq('Lord of the Rings'))
        expect(body['series']['installments'][0]['name']).to(eq('Fellowship'))
      end

    end
  end
end
