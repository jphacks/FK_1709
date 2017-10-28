class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, omniauth_providers: [:facebook]

  validates :name, presence: true
  validates :sex, presence: true
  validates :birthday, presence: true

  enum sex: { male: 0, female: 1 }

  enum married_status: { unanswered_ms: 0, unmarried: 1,　divorce: 2, widowed: 3 }
              
end
