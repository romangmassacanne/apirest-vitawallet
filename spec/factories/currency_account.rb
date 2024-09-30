FactoryBot.define do
    factory :currency_account, class: 'Api::V1::CurrencyAccount' do
      association :user
      association :currency
      balance {10.000}
    end
end 
  