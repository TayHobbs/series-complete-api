class AddInstallmentsToSeries < ActiveRecord::Migration[5.0]
  def change
    change_table :series do |t|
      t.references :installments, foreign_key: true
    end
  end
end
