require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  let!(:user) { create(:user) }
  let!(:usd) { create(:currency, name: 'USD',api_reference: nil,  precision: 2) }
  let!(:btc) {create(:currency)}
  let!(:currency_account) {create(:currency_account, user: user, currency: usd, balance: 10000)}

  let(:token_new) do
    post "/api/v1/auth/login", params: { email: user.email, password: user.password }
    JSON.parse(response.body)["token"]
  end

  let(:token) do
    {  "token": token_new  }
  end

  describe "POST /api/v1/transactions" do
    it "creates a new transaction" do
      params = {
        "transaction": {
          "currency_from": "USD",
          "currency_to": "BTC",
          "amount_from": 100
        }
      }
    post "/api/v1/transactions", params: params, headers: token

    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)).to include(
        'currency_from' => 'USD',
        'currency_to' => 'BTC',
        'amount_from' => "100,00 USD"
      )
    end

    it "cannot create a transaction because the balance is insufficient" do
      params_to_fail = {
        "transaction": {
          "currency_from": "USD",
          "currency_to": "BTC",
          "amount_from": 50000
        }
      }
      post "/api/v1/transactions", params: params_to_fail, headers: token

      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to include('error')
      expect(parsed_response['error']).to include("El usuario no posee suficiente saldo para realizar la transacción")
    end 
  end

  describe "GET /api/v1/transactions/:id" do
    let!(:transaction) { create(:transaction, user: user, currency_from: usd, currency_to: btc, amount_from: 100, amount_to: 0.05) }
    
    it "returns the details of a specific transaction" do
      get "/api/v1/transactions/#{transaction.id}", headers: token

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include(
        'id' => transaction.id,
        'currency_from' => 'USD',
        'currency_to' => 'BTC',
        'amount_from' => '100,00 USD',
        'amount_to' => '0,05000000 BTC'
      )
    end

    it "returns not found for non-existent transaction" do
      get "/api/v1/transactions/0", headers: token
      expect(response).to have_http_status(:not_found)
    end
    
  end

  describe "GET /api/v1/transactions" do
    let!(:transaction2) { create(:transaction, user: user, currency_from: usd, currency_to: btc, amount_from: 100, amount_to: 0.05) }
    let!(:transaction3) { create(:transaction, user: user, currency_from: btc, currency_to: usd, amount_from: 1, amount_to: 100) }

    it "returns all transactions for current user" do
      get "/api/v1/transactions", headers: token

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)


      expect(json_response.size).to eq(2)

      expect(json_response[0]).to include(
      'currency_from' => 'USD',
      'currency_to' => 'BTC',
      'amount_from' => '100,00 USD',
      'amount_to' => '0,05000000 BTC'
    )
    expect(json_response[1]).to include(
      'currency_from' => 'BTC',
      'currency_to' => 'USD',
      'amount_from' => '1,00000000 BTC',
      'amount_to' => '100,00 USD'
    )
    end
    
  end




end