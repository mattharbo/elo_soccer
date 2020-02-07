class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :fixture, foreign_key: true
      t.references :eventtype, foreign_key: true
      t.string :minute
      t.references :player
      t.references :team, foreign_key: true
      t.references :other_player

      t.timestamps
    end
  end
end
