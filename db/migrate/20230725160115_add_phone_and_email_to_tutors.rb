class AddPhoneAndEmailToTutors < ActiveRecord::Migration[7.0]
  def change
    add_column :tutors, :phone, :string
    add_column :tutors, :email, :string

    add_index :tutors, :phone, unique: true
    add_index :tutors, :email, unique: true
  end
end