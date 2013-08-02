class SingleUseLogin < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :token

  before_create :generate_token

  def generate_token
    self.token ||= Randy.token(30)
  end

  def get_user_and_destroy!
    return self.user
  ensure
    self.destroy!
  end
end
