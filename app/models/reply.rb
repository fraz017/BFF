require 'obscenity/active_model'
class Reply < ApplicationRecord
  belongs_to :message
  belongs_to :sender, foreign_key: "sender_id", class_name: "User"
  validates :content,  obscenity: { sanitize: true }
  has_many :likes
  
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
      self.sender.minus_messaging_score(50)
      Delayed::Job.enqueue BlockUnblockUsersJob.new(self.sender.id, "unblock"), 0, 1.week.from_now.getutc
    end
  end
end
