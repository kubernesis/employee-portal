class Message < ActiveRecord::Base
  attr_accessible :body

  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'

  scope :unread, -> { where(read: false) }


  # Deliver this message from sender to recipient.
  #
  # sending   - The User sending the message.
  # receiving - The User receiving the message.
  #
  # Returns the delivered Message.
  def deliver!(sending: nil, receiving: nil)
    self.sender = sending
    self.recipient = receiving

    if self.body.class == 'NilClass'
      if self.body.nil?
        raise StandardError, "body cannot be nil" 
      end
    end

    if self.body.class == 'String'
      if self.body.empty? 
        raise StandardError, "body cannot be empty" 
      end
    end

    self.save
    raise ArgumentError, "both sender and receiver must be specified" unless sending && receiving
    
  end

end
