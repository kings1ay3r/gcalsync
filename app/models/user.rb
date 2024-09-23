class User < ApplicationRecord
  has_secure_password
  has_many :calendars, dependent: :destroy

  attribute :last_signed_in_at, :datetime
  # after_update :update_last_signed_in_at
  before_save :update_last_signed_in_at, if: :signed_in?


  validates :email, presence: true, uniqueness: true


  private
  def signed_in?
    true # TODO: set up authentication
  end

  def update_last_signed_in_at
    self.last_signed_in_at = Time.current
  end
end
