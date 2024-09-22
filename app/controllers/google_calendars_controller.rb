require "googleauth"
require "google/apis/calendar_v3"
require_relative "../../lib/in_memory_token_store"  # Adjust the path as needed

class GoogleCalendarsController < ApplicationController
    before_action :require_login

    def connect
        client_id = Google::Auth::ClientId.new(
          ENV["GOOGLE_CLIENT_ID"],
          ENV["GOOGLE_CLIENT_SECRET"]
        )

        token_store = InMemoryTokenStore.new

        authorizer = Google::Auth::UserAuthorizer.new(
          client_id,
          Google::Apis::CalendarV3::AUTH_CALENDAR,
          token_store
        )

        callback_url = ENV["GOOGLE_CALLBACK_URL"]

        auth_url = authorizer.get_authorization_url(
          base_url: callback_url
        )

        redirect_to auth_url, allow_other_host: true
      end

      def callback
        client_id = Google::Auth::ClientId.new(
          ENV["GOOGLE_CLIENT_ID"],
          ENV["GOOGLE_CLIENT_SECRET"]
        )

        token_store = InMemoryTokenStore.new

        authorizer = Google::Auth::UserAuthorizer.new(
          client_id,
          Google::Apis::CalendarV3::AUTH_CALENDAR,
          token_store
        )

        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: current_user.id,
          code: params[:code],
          base_url: ENV["GOOGLE_CALLBACK_URL"]
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
        cal.user_id = current_user.id
      end

      events = service.list_events(google_calendar.id)
      events.items.each do |google_event|
        Event.find_or_create_by(
          calendar: calendar,
          google_event_id: google_event.id
        ) do |event|
          event.title = google_event.summary

          if google_event.start.date
            event.start_time = google_event.start.date.to_time.beginning_of_day
            event.end_time = google_event.end.date.to_time.end_of_day
          else
            event.start_time = google_event.start.date_time
            event.end_time = google_event.end.date_time
          end
        end
      end
    end
  end

  def set_up_watch_request
    service = initialize_google_calendar_service

    calendar_list = service.list_calendar_lists
    calendar_list.items.each do |calendar|
      watch = Watch.find_by(calendar_id: calendar.id)
      if watch
        destroy_watch(calendar.id)
      end

      watch = create_watch_request(service, calendar.id)
      Watch.create(calendar_id: calendar.id, watch_id: watch[:resourceId], expiration: Time.at(watch[:expiration] / 1000))
    end
  end

  def create_watch_request(service, calendar_id)
    request_body = {
      type: "web_hook",
      address: ENV["WEBHOOK_URL"],
      token: SecureRandom.hex(16)
    }

    service.insert_channel("v3", request_body, calendar_id)
  end

  def destroy_watch(calendar_id)
    watch = Watch.find_by(calendar_id: calendar_id)
    return unless watch

    service = initialize_google_calendar_service
    service.stop_channel(watch.watch_id)

    watch.destroy
  end

  def initialize_google_calendar_service
    client_id = Google::Auth::ClientId.new(
      ENV["GOOGLE_CLIENT_ID"],
      ENV["GOOGLE_CLIENT_SECRET"]
    )
    token_store = InMemoryTokenStore.new
    authorizer = Google::Auth::UserAuthorizer.new(
      client_id,
      Google::Apis::CalendarV3::AUTH_CALENDAR,
      token_store
    )
    credentials = authorizer.get_credentials(current_user.id)
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = ENV["GOOGLE_APP_NAME"]
    service.authorization = credentials
    service
  end
end
