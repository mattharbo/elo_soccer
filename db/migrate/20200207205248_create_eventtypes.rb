class CreateEventtypes < ActiveRecord::Migration[5.2]
  def change
    create_table :eventtypes do |t|
      t.string :name

      t.timestamps
    end
  end
end
