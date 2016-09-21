class InstallmentsController < ApplicationController
  before_action :set_installment, except: [:create]

  def create
    @installment = Installment.new(installment_params)
    if @installment.save
      return render json: @installment, status: :created, location: @installment
    else
      return render json: @installment.errors, status: :unprocessable_entity
    end
  end

  def update
    @installment.update(installment_params.except(:id))
    render json: @installment
  end

  def destroy
    if @installment.destroy
      return render(json: {'message' => 'Installment successfully deleted!'})
    end
  end

  private
    def set_installment
      @installment = Installment.find(params[:id])
    end
    def installment_params
      params.require(:installment).permit(:id, :name, :complete, :series_id)
    end
end
