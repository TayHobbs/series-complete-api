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

  describe 'DELETE destroy' do
    it 'destroys the requested installment' do
      series = Series.create!({:title => 'Lord of the Rings'})
      installment = Installment.create!({:name => 'Fellowship', :complete => false, :series => series})
      expect {
        delete :destroy, params: {:id => installment.to_param}
      }.to change(Installment, :count).by(-1)
    end

    it 'returns success message on success' do
      series = Series.create!({:title => 'Lord of the Rings'})
      installment = Installment.create!({:name => 'Fellowship', :complete => false, :series => series})
      delete :destroy, params: {:id => installment.to_param}
      body = JSON.parse(response.body)
      expect(body).to(eq({'message' => 'Installment successfully deleted!'}))
    end
  end

end
