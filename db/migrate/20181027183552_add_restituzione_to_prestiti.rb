class AddRestituzioneToPrestiti < ActiveRecord::Migration[5.2]
  def change
    add_column :prestiti, :restituzione, :datetime
  end
end
