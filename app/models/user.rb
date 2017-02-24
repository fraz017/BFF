class User < ApplicationRecord
	has_one :chat_room
	has_many :messages, foreign_key: "sender_id", class_name: "Message"
	has_many :replies, foreign_key: "sender_id", class_name: "Reply"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:facebook]

  validates_presence_of :location, :education, :gender, :on => :update       
  after_create :create_room


  def create_room
		ChatRoom.create(user_id: self.id)
	end

  def self.from_omniauth(auth)
	  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	    user.email = auth.info.email
	    user.password = Devise.friendly_token[0,20]
	    user.name = auth.info.name   # assuming the user model has a name
	    # user.image = auth.info.image
	    user.gender = auth.info.gender
	    user.age_range = auth.info.age_range
	    # assuming the user model has an image
	    # If you are using confirmable and the provider(s) you use validate emails, 
	    # uncomment the line below to skip the confirmation emails.
	    # user.skip_confirmation!
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
