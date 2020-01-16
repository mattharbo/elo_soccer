class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :acronym
      t.string :city
      t.string :light_color

      t.timestamps
    end
  end
end
