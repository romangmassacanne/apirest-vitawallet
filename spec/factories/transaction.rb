FactoryBot.define do
    factory :transaction, class: 'Api::V1::Transaction' do
      association :user
      association :currency_from, factory: :currency
      association :currency_to, factory: :currency
      amount_from { 100.0 }
      amount_to { 0.005 }
    end
end 
  