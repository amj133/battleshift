FactoryBot.define do
  factory :user do
    name "Sam"
    email "sam@gmail.com"
    password "test1"
    password_confirmation "test1"
    api_key ENV['USER_API_KEY']
    status "active"
  end

  factory :player, class: User do
    name "Bill123"
    email "bill@gmail.com"
    password "test1"
    password_confirmation "test1"
    status "active"
  end

  factory :opponent, class: User do
    name "Jane123"
    email "jane@gmail.com"
    password "test1"
    password_confirmation "test1"
    status "active"
  end
end
