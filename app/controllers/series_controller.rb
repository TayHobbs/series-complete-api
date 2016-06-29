class SeriesController < ApplicationController
  def create
    @series = Series.new(series_params.except(:installments))
    if @series.save
      installments = series_params[:installments]
      if installments
        installments.each do |i|
          i[:series] = @series
          installment = Installment.new(i)
          installment.save()
        end
      end
      return render json: @series, status: :created, location: @series
    else
      return render json: @series.errors, status: :unprocessable_entity
    end
  end

  private
    def series_params
      params.require(:series).permit(:title, :complete, :installments => [:name, :complete])
    end
end
