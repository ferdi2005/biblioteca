class AddStatoToLibri < ActiveRecord::Migration[5.2]
  def change
    add_column :libri, :stato, :integer
  end
end
