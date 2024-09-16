require 'rails_helper'

RSpec.describe CalendarsController, type: :controller do
  let(:user) { create(:user) }
  let(:calendar) { create(:calendar, user: user) }
  let!(:event) { create(:event, calendar: calendar) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    context 'when calendar_id is present' do
      it 'shows events for the specific calendar' do
        get :index, params: { calendar_id: calendar.id }
        expect(assigns(:calendar)).to eq(calendar)
        expect(assigns(:events)).to include(event)
        expect(flash[:alert]).to be_nil
      end

      it 'handles calendar not found' do
        get :index, params: { calendar_id: 'invalid' }
        expect(assigns(:calendar)).to be_nil
        expect(assigns(:events)).to be_empty
        expect(flash[:alert]).to eq('Calendar not found.')
      end
    end

    context 'when calendar_id is not present' do
      it 'shows all calendars for the user' do
        get :index
        expect(assigns(:calendars)).to include(calendar)
      end
    end
  end
end
