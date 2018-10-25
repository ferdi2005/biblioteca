class CreateLibri < ActiveRecord::Migration[5.2]
  def change
    create_table :libri do |t|
      t.string :titolo
      t.string :autore
      t.string :isbn
      t.references :utente

      t.timestamps
    end
  end
end
