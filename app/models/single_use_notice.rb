class SingleUseNotice < ActiveRecord::Base
  validates_presence_of :message

  before_create :generate_token

  def generate_token
    self.token ||= Randy.string(30)
  end

  def get_message_and_destroy!
    return self.message
  ensure
    self.destroy!
  end
end
