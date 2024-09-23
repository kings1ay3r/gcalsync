class WatchRenewalJob
  include Sidekiq::Worker

  def perform
    Watch.where("expiration < ?", 1.day.from_now).find_each do |watch|
      renew_watch(watch)
    end
  end

  private

  def renew_watch(watch)
    service = initialize_google_calendar_service

    service.stop_channel(watch.watch_id)

    calendar_id = watch.calendar_id
    new_watch = create_watch_request(service, calendar_id)

    watch.update(
      watch_id: new_watch[:resourceId],
      expiration: Time.at(new_watch[:expiration] / 1000)
    )
  end

  def create_watch_request(service, calendar_id)
    request_body = {
      type: "web_hook",
      address: ENV["WEBHOOK_URL"],
      token: SecureRandom.hex(16)
    }

    service.insert_channel("v3", request_body, calendar_id)
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
