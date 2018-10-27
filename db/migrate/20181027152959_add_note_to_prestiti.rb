class AddNoteToPrestiti < ActiveRecord::Migration[5.2]
  def change
    add_column :prestiti, :note, :text
  end
end
