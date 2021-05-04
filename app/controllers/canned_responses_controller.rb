class CannedResponsesController < ApplicationController
  before_action :set_canned_response, only: %i[edit update destroy]

  def new
    @canned_response = CannedResponse.new
  end

  def create
    @canned_response = current_team.canned_responses.new(canned_params)
    if @canned_response.save
      redirect_to canned_responses_settings_path, notice: t(".created_successfully")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @canned_response.update(canned_params)
      redirect_to canned_responses_settings_path, notice: t(".updated_successfully")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @canned_response.destroy
    redirect_to canned_responses_settings_path, notice: t(".deleted_successfully")
  end

  private

  def set_canned_response
    @canned_response = current_team.canned_responses.find(params[:id])
  end

  def canned_params
    params.require(:canned_response).permit(:label, :content)
  end
end
