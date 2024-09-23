class Calendar < ApplicationRecord
    has_many :events, dependent: :destroy
    has_many :calendar_users
  has_many :users, through: :calendar_users

    validates :google_id, presence: true, uniqueness: true

    belongs_to :user
    has_many :events
end
