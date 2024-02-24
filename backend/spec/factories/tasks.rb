# spec/factories/tasks.rb
FactoryBot.define do
  factory :task do
    title { "Example Task Title" }
    description { "Example Task Description" }
  end
end
