class AddPasswordToUtenti < ActiveRecord::Migration[5.2]
  def change
    add_column :utenti, :password_digest, :string
  end
end
