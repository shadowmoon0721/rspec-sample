require 'rails_helper'

RSpec.describe "FoodEnquetes", type: :request do
  describe "GET /food_enquetes" do
    it "works! (now write some real specs)" do
      get food_enquetes_path
      expect(response).to have_http_status(200)
    end
  end
end
