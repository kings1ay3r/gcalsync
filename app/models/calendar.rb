class Calendar < ApplicationRecord
    has_many :events, dependent: :destroy
    belongs_to :user
    has_many :events
end
