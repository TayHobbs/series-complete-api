require 'rails_helper'

RSpec.describe Installment, type: :model do
  it 'belongs to a series' do
    series = Series.create!({:title => 'Lord of the Rings'})
    installment = Installment.create!({:name => 'Fellowship', :complete => false, :series => series})
    expect(installment.series).to eq series
  end
end
