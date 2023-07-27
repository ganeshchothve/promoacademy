class Course < ApplicationRecord
  has_many :tutors
  accepts_nested_attributes_for :tutors

  validates :name, presence: true, uniqueness: true
  # validates_associated should not be present in both associated models, as it will lead to circular dependency
  # and will fall in infinite loop
  validates_associated :tutors
end
