FactoryBot.define do
    factory :currency, class: 'Api::V1::Currency' do
      name {"BTC"}
      api_reference {"https://api.coindesk.com/v1/bpi/currentprice/USD.json"}
      precision {8}
    end
end 
  