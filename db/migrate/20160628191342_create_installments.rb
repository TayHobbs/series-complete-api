class CreateInstallments < ActiveRecord::Migration[5.0]
  def change
    create_table :installments do |t|
      t.string :name
      t.boolean :complete
      t.belongs_to :series, foreign_key: true

      t.timestamps
    end
  end
end
