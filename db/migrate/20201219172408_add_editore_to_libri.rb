class AddEditoreToLibri < ActiveRecord::Migration[6.1]
  def change
    add_column :libri, :editore, :string
  end
end
