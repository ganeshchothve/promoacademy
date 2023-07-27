FactoryBot.define do

  factory :course do
    sequence(:name) { |n| "Course #{n}" }
  end

  factory :tutor do
    sequence(:name) { |n| "Tutor #{n}" }
    course
  end

end