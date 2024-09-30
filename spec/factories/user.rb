FactoryBot.define do
    factory :user, class: 'Api::V1::User' do
      username {"admin"}
      email { "admin@gmail.com" }
      password { "admin" }
    end
end 
  