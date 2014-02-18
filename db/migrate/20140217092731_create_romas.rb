class CreateRomas < ActiveRecord::Migration
  def change
    create_table :romas do |t|

      t.timestamps
    end
  end
end
