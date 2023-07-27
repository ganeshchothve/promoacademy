require 'rails_helper'

RSpec.describe Course, type: :model do

  describe 'associations' do
    context 'has many tutors' do
      it 'has many tutors' do
        course_tutor_association = described_class.reflect_on_association(:tutors)
        expect(course_tutor_association.macro).to eq(:has_many)
      end
    end
  end

  describe 'validations' do
    context 'validate name' do

      it 'should validate presence of name' do
        course = build(:course, name: nil)
        expect(course.valid?).to eq(false)
        expect(course.errors.messages[:name]).to eq(["can't be blank"])
      end

      it 'should validate uniqueness of name' do
        create(:course, name: 'Ruby on Rails')
        course = build(:course, name: 'Ruby on Rails')
        expect(course.valid?).to eq(false)
        expect(course.errors.messages[:name]).to eq(['has already been taken'])
      end
    end
  end

  describe 'nested attributes' do
    context 'creating a course with tutors' do
      it 'should allow creating tutors along with the course' do
        tutors_attributes = [
          { name: 'John Doe', phone: '8390341970', email: 'gaensh@gmail.com' },
          { name: 'Jane Smith', phone: '839034134', email: 'ganesh@game2.com' }
        ]

        course = build(:course, tutors_attributes: tutors_attributes)
        expect(course.valid?).to eq(true)
        expect(course.tutors.size).to eq(2)

        course.save
        expect(Course.count).to eq(1)
        expect(Tutor.count).to eq(2)
      end
    end
  end
end
