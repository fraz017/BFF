require 'obscenity/active_model'
class Message < ApplicationRecord
  has_and_belongs_to_many :chat_rooms
  has_many :replies, dependent: :destroy
  has_one :category
  belongs_to :sender, foreign_key: "sender_id", class_name: "User"
  validates :content,  obscenity: { sanitize: true }

  def add_flag_point
    if self.flagged.nil?
      self.flagged = 1
    else  
      self.flagged += 1
    end
    self.save
    if self.flagged >= 3
    	self.visible = false
    	self.save
    end
  end
end
