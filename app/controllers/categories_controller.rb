class CategoriesController < ApplicationController
  def index
    render json: Category.order(:name)
  end
end
