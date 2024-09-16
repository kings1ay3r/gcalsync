class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    if valid_notification?
      process_notification
      render json: { message: "Received" }, status: :ok
    else
      render json: { message: "Invalid notification" }, status: :unprocessable_entity
    end
  end

  private

  def valid_notification?
    true # TODO: Verify Token
  end

  def process_notification
    notification_data = JSON.parse(request.body.read)

    calendar_id = notification_data["resourceId"]

    service = initialize_google_calendar_service

    events = service.list_events(calendar_id)

    process_events(events.items, calendar_id)

    create_watch_request_for(calendar_id)
  end

  def process_events(events, calendar_id)
    events.each do |event|
      if event.deleted
        delete_event(event.id, calendar_id)
      else
        upsert_event(event, calendar_id)
      end
    end
  end

  def upsert_event(event, calendar_id)
    db_event = Event.find_or_initialize_by(google_event_id: event.id, calendar_id: calendar_id)
    db_event.update(
      title: event.summary,
      start_time: event.start.date_time || event.start.date,
      end_time: event.end.date_time || event.end.date
    )
  end

  def delete_event(event_id, calendar_id)
    db_event = Event.find_by(google_event_id: event_id, calendar_id: calendar_id)
    if db_event
      db_event.update(deleted_at: Time.current)
    end
  end

  def initialize_google_calendar_service
    client_id = Google::Auth::ClientId.new(ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"])
    token_store = InMemoryTokenStore
    authorizer = Google::Auth::UserAuthorizer.new(client_id, Google::Apis::CalendarV3::AUTH_CALENDAR, token_store)
    credentials = authorizer.get_credentials(current_user.id)
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = "Your App Name"
    service.authorization = credentials
    service
  end
end
