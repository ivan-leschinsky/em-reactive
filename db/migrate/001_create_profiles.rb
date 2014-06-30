class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles, force: true do |t|
      t.string  :first_name
      t.string  :last_name
      t.integer :age
      t.string  :address
    end
  end
end
