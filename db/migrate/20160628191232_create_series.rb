class CreateSeries < ActiveRecord::Migration[5.0]
  def change
    create_table :series do |t|
      t.string :title
      t.string :type
      t.string :complete
      t.references :installments, foreign_key: true

      t.timestamps
    end
  end
end
