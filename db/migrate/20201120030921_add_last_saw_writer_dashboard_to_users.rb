class AddLastSawWriterDashboardToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_saw_writer_dashboard, :string
  end
end
