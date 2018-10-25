class AddDettagliToLibri < ActiveRecord::Migration[5.2]
  def change
    add_column :libri, :costo, :float
    add_column :libri, :trama, :text
    add_column :libri, :foto, :string
    add_column :libri, :voto, :integer
  end
end
