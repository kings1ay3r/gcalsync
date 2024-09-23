class Watch < ApplicationRecord
  belongs_to :calendar
  validates :calendar_id, :watch_id, :expiration, presence: true
end
