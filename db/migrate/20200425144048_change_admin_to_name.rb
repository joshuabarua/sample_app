class ChangeAdminToName < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :admin, :name
  end
end
