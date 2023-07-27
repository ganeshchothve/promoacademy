require 'rails_helper'

RSpec.describe Tutor, type: :model do
  describe 'associations' do
    it 'belongs to a course' do
      tutor_course_association = described_class.reflect_on_association(:course)
      expect(tutor_course_association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    subject(:tutor) { build(:tutor) }

    it 'validates uniqueness of phone' do
      create(:tutor, phone: '8390341970')
      tutor.phone = '8390341970'
      expect(tutor.valid?).to eq(false)
      expect(tutor.errors.messages[:phone]).to eq(['has already been taken'])
    end

    it 'validates uniqueness of email' do
      create(:tutor, email: 'tutor@example.com')
      tutor.email = 'tutor@example.com'
      expect(tutor.valid?).to eq(false)
      expect(tutor.errors.messages[:email]).to eq(['has already been taken'])
    end

    it 'validates phone or email presence' do
      tutor.phone = nil
      tutor.email = nil
      expect(tutor.valid?).to eq(false)
      expect(tutor.errors.messages[:base]).to eq(['Tutor should have phone or email'])

      tutor.phone = '8390341970'
      expect(tutor.valid?).to eq(true)

      tutor.phone = nil
      tutor.email = 'tutor@example.com'
      expect(tutor.valid?).to eq(true)
    end
  end
end
