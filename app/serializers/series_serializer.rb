class SeriesSerializer < ActiveModel::Serializer
  attributes :id, :title, :complete, :installments

  def complete
    installments_complete = []
    object.installments.each do |i|
      installments_complete.push(i.complete)
    end
    installments_complete.any?
  end
end
