FactoryBot.define do
  factory :user do
    name "Jane123"
    email "jane@gmail.com"
    password "test1"
    password_confirmation "test1"
    api_key ENV['USER_API_KEY']
    status "active"
  end
end
