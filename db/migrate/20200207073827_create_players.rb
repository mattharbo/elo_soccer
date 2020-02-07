class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.text :first_name
      t.text :last_name
      t.text :nationality
      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
