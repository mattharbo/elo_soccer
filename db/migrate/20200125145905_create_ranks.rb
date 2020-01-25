class CreateRanks < ActiveRecord::Migration[5.2]
  def change
    create_table :ranks do |t|
      t.references :fixture, foreign_key: true
      t.references :team, foreign_key: true
      t.float :level

      t.timestamps
    end
  end
end
