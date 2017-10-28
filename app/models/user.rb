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

  enum married_status: { unanswered_ms: 0, unmarried: 1, divorce: 2, widowed: 3 }

  mount_uploader :image, ImageUploader

  def age
    date_format = "%Y%m%d"
    (Date.today.strftime(date_format).to_i - birthday.strftime(date_format).to_i) / 10000
  end
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      # user.avatar = auth.info.image
    end
  end
end
