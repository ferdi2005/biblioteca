class CreateUtenti < ActiveRecord::Migration[5.2]
  def change
    create_table :utenti do |t|
      t.string :cognome
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
