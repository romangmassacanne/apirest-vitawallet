require 'rails_helper'

RSpec.describe "Bitcoin Price", type: :request do
  let!(:user) { create(:user) }
  let!(:currency) {create(:currency)}

  let(:token_new) do
    post "/api/v1/auth/login", params: { email: user.email, password: user.password }
    JSON.parse(response.body)["token"]
  end

  let(:token) do
    {  "token": token_new  }
  end

  describe "GET /api/v1" do
    it "returns a successful response, a json and bitcoin_price" do
      get "/api/v1", params: {}, headers: token
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body)).to have_key("bitcoin_price")
    end
  end
end