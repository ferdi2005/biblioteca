class CreatePrestiti < ActiveRecord::Migration[5.2]
  def change
    create_table :prestiti do |t|
      t.references :utente, foreign_key: true
      t.references :libro, foreign_key: true

      t.timestamps
    end
  end
end
