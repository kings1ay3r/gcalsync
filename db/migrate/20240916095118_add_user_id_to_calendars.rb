class AddUserIdToCalendars < ActiveRecord::Migration[7.2]
  def change
    add_column :calendars, :user, foreign_key: true
  end
end
