require 'obscenity/active_model'
class Message < ApplicationRecord
  has_and_belongs_to_many :chat_rooms
  has_many :replies, dependent: :destroy
  has_one :category
  belongs_to :sender, foreign_key: "sender_id", class_name: "User"
  has_many :likes
  before_save :validates_content
  after_save :check_message_time  

  def validates_content
    mystring = content.split(" ")
    mystring.each do |s|
      match = AbuseFilter.where("abuse like ?","%#{s}%")
      if match.present?
        content[s] = "*****"
      end
    end
  end

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
      self.sender.blocked = true
      self.sender.save
      Delayed::Job.enqueue BlockUnblockUsersJob.new(self.sender.id, "unblock"), 0, 1.week.from_now.getutc
    end
  end

  def check_message_time
    begin
      messages = self.sender.messages.where("created_at > ?", 60.seconds.ago)
      if messages.count >= 3
        messages.first.sender.blocked = true
        messages.first.sender.save
        Delayed::Job.enqueue BlockUnblockUsersJob.new(self.sender.id, "unblock"), 0, 5.minutes.from_now.getutc
      end
    rescue
    end
  end
end
