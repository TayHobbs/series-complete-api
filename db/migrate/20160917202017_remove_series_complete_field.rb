class RemoveSeriesCompleteField < ActiveRecord::Migration[5.0]
  def change
    remove_column :series, :complete, :string
  end
end
