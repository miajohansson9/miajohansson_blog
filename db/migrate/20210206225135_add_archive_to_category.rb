class AddArchiveToCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :archive, :boolean
  end
end
