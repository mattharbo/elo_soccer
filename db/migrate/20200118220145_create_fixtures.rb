class CreateFixtures < ActiveRecord::Migration[5.2]
  def change
    create_table :fixtures do |t|
      t.references :home_team
      t.references :away_team
      t.integer :score_home
      t.integer :score_away
      t.boolean :completed

      t.timestamps
    end
  end
end
