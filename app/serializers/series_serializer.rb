class SeriesSerializer < ActiveModel::Serializer
  attributes :id, :title, :complete, :installments

  def complete
    object.complete == "t"
  end
end

