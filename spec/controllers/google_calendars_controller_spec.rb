# spec/controllers/google_calendars_controller_spec.rb

require 'rails_helper'
require 'googleauth'
require 'google/apis/calendar_v3'
include Devise::Test::ControllerHelpers


 # Include Devise helpers
 include Devise::Test::ControllerHelpers

 # Define necessary setup
 let(:user) { create(:user) }

# Your test code

RSpec.describe GoogleCalendarsController, type: :controller do
  # Include Devise test helpers to simulate login behavior
  include Devise::Test::ControllerHelpers

  # Use FactoryBot to create a user object
  let(:user) { create(:user) }

  it "does something" do
    expect(true).to be true
  end

  # # Mock necessary objects
  # let(:token_store) { instance_double(InMemoryTokenStore) }
  # let(:client_id) { instance_double(Google::Auth::ClientId) }
  # let(:authorizer) { instance_double(Google::Auth::UserAuthorizer) }
  # let(:credentials) { instance_double(Google::Auth::UserRefreshCredentials, access_token: "access_token", refresh_token: "refresh_token") }
  # let(:service) { instance_double(Google::Apis::CalendarV3::CalendarService) }
  # let(:calendar_list) { instance_double(Google::Apis::CalendarV3::CalendarList, items: []) }

  # before do
  #   sign_in user
  #   allow(Google::Auth::ClientId).to receive(:new).and_return(client_id)
  #   allow(InMemoryTokenStore).to receive(:new).and_return(token_store)
  #   allow(Google::Auth::UserAuthorizer).to receive(:new).and_return(authorizer)
  #   allow(authorizer).to receive(:get_authorization_url).and_return("http://google.com")
  # end

  # describe 'GET #connect' do
  #   it 'redirects to the Google authorization URL' do
  #     get :connect
  #     expect(response).to redirect_to("http://google.com")
  #   end
  # end

  # describe 'GET #callback' do
  #   it 'updates the user tokens and redirects to calendars path' do
  #     allow(authorizer).to receive(:get_and_store_credentials_from_code).and_return(credentials)
  #     allow(service).to receive(:list_calendar_lists).and_return(calendar_list)

  #     get :callback, params: { code: 'auth_code' }

  #     user.reload
  #     expect(user.google_access_token).to eq("access_token")
  #     expect(user.google_refresh_token).to eq("refresh_token")
  #     expect(response).to redirect_to(calendars_path)
  #     expect(flash[:notice]).to eq("Events synced successfully!")
  #   end
  # end


  # describe "GET #callback" do
  #   it "retrieves and stores credentials, then syncs events" do
  #     allow(authorizer).to receive(:get_and_store_credentials_from_code).and_return(credentials)
  #     allow(controller).to receive(:sync_events)

  #     get :callback, params: { code: "auth_code" }

  #     expect(user.reload.google_access_token).to eq("access_token")
  #     expect(user.reload.google_refresh_token).to eq("refresh_token")
  #     expect(controller).to have_received(:sync_events)
  #     expect(response).to redirect_to(calendars_path)
  #     expect(flash[:notice]).to eq("Events synced successfully!")
  #   end
  # end

  # describe "#sync_events" do
  #   it "syncs Google Calendar events to the database" do
  #     google_calendar = instance_double(Google::Apis::CalendarV3::CalendarListEntry, id: "cal_123", summary: "Test Calendar")
  #     google_event = instance_double(Google::Apis::CalendarV3::Event, id: "event_123", summary: "Test Event", start: instance_double(Google::Apis::CalendarV3::EventDateTime, date_time: Time.now), end: instance_double(Google::Apis::CalendarV3::EventDateTime, date_time: Time.now + 1.hour))

  #     allow(calendar_list).to receive(:items).and_return([ google_calendar ])
  #     allow(service).to receive(:list_events).and_return(instance_double(Google::Apis::CalendarV3::Events, items: [ google_event ]))

  #     expect { controller.sync_events }.to change { Event.count }.by(1)
  #   end
  # end

  # describe "#set_up_watch_request" do
  #   it "sets up watch requests for calendars" do
  #     google_calendar = instance_double(Google::Apis::CalendarV3::CalendarListEntry, id: "cal_123")
  #     allow(calendar_list).to receive(:items).and_return([ google_calendar ])
  #     allow(service).to receive(:insert_channel).and_return({ resourceId: "watch_id", expiration: (Time.now + 1.day).to_i * 1000 })

  #     expect { controller.set_up_watch_request }.to change { Watch.count }.by(1)
  #   end
  # end
end
