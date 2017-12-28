class User < ApplicationRecord
	has_one :chat_room
	has_many :messages, foreign_key: "sender_id", class_name: "Message"
	has_many :replies, foreign_key: "sender_id", class_name: "Reply"
	has_many :logs, foreign_key: "sender_id", class_name: "Log"
  has_many :likes
  has_many :matchers
  has_many :single_messages
  has_many :rooms, through: :single_messages
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:facebook]

  as_enum :role, admin: 0, user: 1, manager: 2       

  validates_presence_of :name, :location, :education, :gender, :on => :update       
  after_create :create_room
  before_update :set_points
  scope :users, -> { where(role_cd: 1) }

  def set_points
  	points = 0
  	if self.location.present?
  		points+= 10
  	end
  	if self.education.present?
  		points+= 5
  	end
  	if self.gender.present?
  		points+= 5
  	end
  	if self.name.present?
  		points+= 5
  	end
  	self.score = points
  end

  def admin?
    role == :admin
  end

  def add_loyalty_score(points)
    if self.loyalty_score.nil?
      score = 0
    else
      score = self.loyalty_score + points
    end
    self.update_attributes(loyalty_score: score)
  end

  def add_messaging_score(points)
    if self.messaging_score.nil?
      score = 0
    else
      score = self.messaging_score + points
    end
    self.update_attributes(messaging_score: score)
  end

  def minus_messaging_score(points)
    if self.messaging_score.nil? or self.messaging_score == 0 or self.messaging_score <= 20
      score = 0
    else
      score = self.messaging_score - points
    end
    self.update_attributes(messaging_score: score)
  end

  def minus_loyalty_score(points)
    if self.loyalty_score.nil? or self.loyalty_score == 0 or self.loyalty_score <= 20
      score = 0
    else
      score = self.loyalty_score - points
    end
    self.update_attributes(loyalty_score: score)
  end

  def create_room
		ChatRoom.create(user_id: self.id)
	end

  def add_flag_point
    if self.flagged.nil?
      self.flagged = 1
    else  
      self.flagged += 1
    end
    self.save
  end

  def self.from_omniauth(auth)
	  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	    user.email = auth.info.email
	    user.password = Devise.friendly_token[0,20]
	    user.name = auth.info.name   # assuming the user model has a name
	    # user.image = auth.info.image
	    user.gender = auth.info.gender
	    user.age_range = auth.info.age_range
      user.confirmed_at = Time.now
	    # assuming the user model has an image
	    # If you are using confirmable and the provider(s) you use validate emails, 
	    # uncomment the line below to skip the confirmation emails.
	    user.skip_confirmation!
	  end
	end
   
	
	def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end    
end
