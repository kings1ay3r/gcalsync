require "googleauth"
require "google/apis/calendar_v3"

class GoogleCalendarsController < ApplicationController
  def connect
    client_id = ENV["GOOGLE_CLIENT_ID"]
    client_secret = ENV["GOOGLE_CLIENT_SECRET"]
    callback_url = ENV["GOOGLE_CALLBACK_URL"]

    authorizer = Google::Auth::WebUserAuthorizer.new(
      client_id,
      Google::Apis::CalendarV3::AUTH_CALENDAR,
      client_secret
    )

    auth_url = authorizer.get_authorization_url(
      base_url: callback_url,
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR
    )

    redirect_to auth_url
  end

  def callback
    client_id = ENV["GOOGLE_CLIENT_ID"]
    client_secret = ENV["GOOGLE_CLIENT_SECRET"]

    authorizer = Google::Auth::WebUserAuthorizer.new(
      client_id,
      Google::Apis::CalendarV3::AUTH_CALENDAR,
      client_secret
    )

    credentials = authorizer.get_credentials_from_code(
      user_id: current_user.id,
      code: params[:code],
      base_url: callback_url
    )

    current_user.update(
      google_access_token: credentials.access_token,
      google_refresh_token: credentials.refresh_token
    )

    sync_events
    redirect_to calendars_path, notice: "Events synced successfully!"
  end

  def sync_events
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = current_user.google_access_token

    calendar_list = service.list_calendar_lists

    calendar_list.items.each do |google_calendar|
      calendar = Calendar.find_or_create_by(google_id: google_calendar.id) do |cal|
        cal.name = google_calendar.summary
      end

      events = service.list_events(google_calendar.id)
      events.items.each do |google_event|
        Event.find_or_create_by(
          calendar: calendar,
          google_event_id: google_event.id
        ) do |event|
          event.title = google_event.summary
          event.start_time = google_event.start.date_time
          event.end_time = google_event.end.date_time
        end
      end
    end
  end
end
