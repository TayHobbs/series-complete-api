require 'rails_helper'

RSpec.describe SeriesController, type: :controller do

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
        expect(body).to(eq({"series" => {"id"=>1, "title"=>"Lord of the Rings", "complete"=>"false", "installments"=>[]}}))
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
