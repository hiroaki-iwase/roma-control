class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.boolean :active
      t.string :name
      t.string :ip
      t.boolean :del_flg

      t.timestamps
    end
  end
end
