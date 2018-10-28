class AddCategoriesToLibri < ActiveRecord::Migration[5.2]
  def change
    add_column :libri, :genere, :string
    add_column :libri, :pagine, :string
  end
end
