class CreateFixtures < ActiveRecord::Migration[5.2]
  def change
    create_table :fixtures do |t|
      t.string :status
      t.date :date
      t.time :time
      t.references :home_team
      t.references :away_team
      t.integer :scorehome
      t.integer :scoreaway
      t.integer :stage
      t.boolean :completed

      t.timestamps
    end
  end
end
