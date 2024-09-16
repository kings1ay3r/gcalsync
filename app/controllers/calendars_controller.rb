class CalendarsController < ApplicationController
  def index
  if params[:calendar_id].present?
    @calendar = current_user.calendars.find_by(id: params[:calendar_id])
    @events = @calendar.events.where(deleted_at: nil)

    if @calendar
      @events = @calendar.events
    else
      flash[:alert] = "Calendar not found."
      @events = []
    end
  else
    @calendars = current_user.calendars.includes(:events)
  end
  end
end
