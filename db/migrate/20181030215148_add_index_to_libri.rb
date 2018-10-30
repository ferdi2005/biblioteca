class AddIndexToLibri < ActiveRecord::Migration[5.2]
  def change
    add_index :libri, :titolo, unique: true
  end
end
