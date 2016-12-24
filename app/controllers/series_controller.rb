class SeriesController < ApplicationController
  before_filter :authenticate_request!
  before_action :set_series, only: [:destroy]

  def index
    @series = Series.all
    return render json: @series
  end

  def create
    @series = Series.new(series_params.except(:installments))
    if @series.save
      create_installments
      return render json: @series, status: :created, location: @series
    else
      return render json: @series.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @series.destroy
      return render(json: {'message' => 'Series successfully deleted!'})
    end
  end

  private
    def set_series
      @series = Series.find(params[:id])
    end

    def create_installments
      if series_params[:installments]
        series_params[:installments].each do |i|
          i[:series] = @series
          installment = Installment.new(i)
          installment.save()
        end
      end
    end

    def series_params
      params.require(:series).permit(:series, :title, :complete, :installments => [:name, :complete])
    end
end
