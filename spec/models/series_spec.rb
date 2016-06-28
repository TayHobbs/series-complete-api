require 'rails_helper'

RSpec.describe Series, type: :model do
  it 'has many installments' do
    series = Series.create!({:title => 'Lord of the Rings', :complete => false})
    installment_one = Installment.create!({:name => 'Fellowship', :complete => false, :series => series})
    installment_two = Installment.create!({:name => 'Two Towers', :complete => false, :series => series})
    expect(series.installments).to eq [installment_one, installment_two]
  end
end
