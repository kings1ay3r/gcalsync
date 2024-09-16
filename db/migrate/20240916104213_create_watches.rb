class CreateWatches < ActiveRecord::Migration[7.2]
  def change
    create_table :watches do |t|
      t.string :calendar_id
      t.string :watch_id
      t.datetime :expiration

      t.timestamps
    end
  end
end
