class SectorsController < ApplicationController
  respond_to :json

  def index
    render json: find_sectors, only: [:id, :name]
  end

  private

  def find_sectors
    if params[:industry_id]
      Industry.find(params[:industry_id]).sectors
    else
      Sector.all
    end
  end
end
