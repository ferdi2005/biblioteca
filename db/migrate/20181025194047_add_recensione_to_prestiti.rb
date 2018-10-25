class AddRecensioneToPrestiti < ActiveRecord::Migration[5.2]
  def change
    add_column :prestiti, :recensione, :text
    add_column :prestiti, :voto, :integer
  end
end
