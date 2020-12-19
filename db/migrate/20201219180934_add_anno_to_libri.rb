class AddAnnoToLibri < ActiveRecord::Migration[6.1]
  def change
    add_column :libri, :anno, :integer
  end
end
