require 'rails_helper'

RSpec.describe InstallmentsController, type: :controller do

  describe 'PATCH update' do
    it 'updates specified record' do
      series = Series.create!({:title => 'Lord of the Rings'})
      installment = Installment.create!({:name => 'Fellowship', :complete => false, :series => series})
      patch :update, params: {id: installment.id, installment: {:id => installment.id, :name => 'Two Towers', :complete => true}}
      body = JSON.parse(response.body)
      expect(body).to(eq({'installment' => {'id'=>installment.id, 'name'=>'Two Towers', 'complete'=>true, "series_id"=>series.id}}))
    end

  end

end
