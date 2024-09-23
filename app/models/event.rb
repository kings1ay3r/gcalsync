class Event < ApplicationRecord
  belongs_to :calendar

  validates :google_event_id, uniqueness: { scope: :calendar_id }

  validates :title, :start_time, :end_time, presence: true
end
