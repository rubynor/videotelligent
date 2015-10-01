class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :code
      t.string :name
      t.boolean :is_interesting
    end
  end
end
