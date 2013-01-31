require 'machinist/active_record'
require 'faker'

Course.blueprint do
  name { "Course #{sn}" }
  start_at { Time.now }
  end_at { Date.today + 30.days }
end

Hole.blueprint do
  course { Course.make! }
  name { "Reverse the order of words #{sn}" }
  description { "Reverse the order of words in a senstence" }
  difficulty { 1 }
  maximum_execution_time { 15 }

  sample_setup { "@sentence = 'The quick brown fox jumps over the lazy dog'" }
  sample_solution { "@sentence.split.reverse.join(' ')" }
  sample_output { "dog lazy the over jumps fox brown quick the" }
  
  creator_id { User.make! } 
  active { true }
end

TestCase.blueprint do
  hole { Hole.make! }
  setup { "@sentence = 'Jinxed wizards pluck ivy from the big quilt'" }
  expected_output { "quilt big the from ivy pluck wizards Jinxed" }
  active { true }
end

Solution.blueprint do
  user { User.make! }
  hole { Hole.make! }
  submitted_at { Time.now }
  code { "@sentence.split.reverse.join(' ')" }
  approved { true }
end

User.blueprint do
  email { Faker::Internet.email }
  password { "password123" }
  password_confirmation { "password123" }
  remember_me { false}
end
