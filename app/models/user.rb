class User < ApplicationRecord
  after_save :save_friends
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

  def opposite_sex
    if sex == 'male'
      return 'female'
    elsif sex == 'female'
      return 'male'
    end
  end

  def age
    date_format = "%Y%m%d"
    (Date.today.strftime(date_format).to_i - birthday.strftime(date_format).to_i) / 10000
  end

  def friend_ids
    friends = Friend.where(user_id: self.id)
    arr = friends.map { |f| f.friend_id}

    friends2 = Friend.where(friend_id: self.id)
    arr2  = friends2.map{ |f| f.user_id }
    arr.concat(arr2).uniq!
    arr
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil # or consider a custom null object
  end
  
  def friends_count
    facebook { |fb| fb.get_connection("me", "friends").size }
  end
  
  def facebook_friends
    facebook { |fb| fb.get_connection("me", "friends") }
  end
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end
  private
  def save_friends 
    facebook_friends.each do |friend|
      Friend.create(user_id: id, friend_id: User.find_by(uid: friend[:id]))
    end
  end

end
