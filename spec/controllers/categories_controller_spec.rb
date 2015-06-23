require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'GET #index' do
    it 'returns a json for all categories' do
      cat1 = create :category
      cat2 = create :category

      expected_response = {
        'categories' => [
          { 'name' => cat1.name },
          { 'name' => cat2.name }
        ]
      }

      get :index
      body = JSON.parse(response.body)
      expect(body).to eq(expected_response)
    end
  end
end
