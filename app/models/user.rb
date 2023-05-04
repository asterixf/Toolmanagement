class User < ApplicationRecord
  validate :password_complexity
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # :registerable registable removedto hide sign up option

  validates :name, :lastname, :plant, :department, :position, presence: true

  def password_complexity
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add :password, 'must include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end
end
