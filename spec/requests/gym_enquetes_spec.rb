require 'rails_helper'

RSpec.describe "GymEnquetes", type: :request do
  describe '正常' do
    it "ページが表示されないこと" do
      get "/gym_enquetes/new" 
      expect(response).to have_http_status(404)
    end
  end
end
