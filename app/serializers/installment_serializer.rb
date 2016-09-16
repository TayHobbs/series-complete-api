class InstallmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :complete, :series_id
end
