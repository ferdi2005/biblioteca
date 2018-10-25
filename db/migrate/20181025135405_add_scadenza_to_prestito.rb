class AddScadenzaToPrestito < ActiveRecord::Migration[5.2]
  def change
    add_column :prestiti, :scadenza, :datetime
    add_column :prestiti, :stato, :integer
    add_column :prestiti, :consegna, :datetime
  end
end
