class AddGoogleTokensToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :google_access_token, :string
    add_column :users, :google_refresh_token, :string
  end
end
