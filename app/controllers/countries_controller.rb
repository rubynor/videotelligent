class CountriesController < ApplicationController

  respond_to :json

  def index
    respond_with Country.where(is_interesting: true).order(:name)
  end
end
