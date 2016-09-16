class InstallmentsController < ApplicationController
  def update
    @installment = Installment.update(installment_params[:id], installment_params.except(:id))
    @installment.save
    render json: @installment
  end

  private
    def installment_params
      params.require(:installment).permit(:id, :name, :complete)
    end
end
