class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.references :calendar, null: false, foreign_key: true
      t.string :title
      t.datetime :start_time
      t.datetime :end_time
      t.string :google_event_id

      t.timestamps
    end
  end
end
