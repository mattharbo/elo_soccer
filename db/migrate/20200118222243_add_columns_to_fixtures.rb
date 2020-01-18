class AddColumnsToFixtures < ActiveRecord::Migration[5.2]
  def change
    add_column :fixtures, :status, :string
    add_column :fixtures, :date, :date
    add_column :fixtures, :time, :time
    add_column :fixtures, :stage, :integer
  end
end
