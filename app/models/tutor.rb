class Tutor < ApplicationRecord
  belongs_to :course
  validates :name, presence: true
  validates :phone, uniqueness: true, allow_blank: true
  validates :email, uniqueness: true, allow_blank: true
  validate :phone_or_email_required

  private

  def phone_or_email_required
    if phone.blank? && email.blank?
      errors.add(:base, "Tutor should have phone or email")
    end
  end
end
