class SeriesSerializer < ActiveModel::Serializer
  attributes :id, :title, :complete, :installments
end

