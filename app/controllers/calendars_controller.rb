class CalendarsController < ApplicationController
  def index
    @calendars = Calendar.includes(:events)
  end
end
