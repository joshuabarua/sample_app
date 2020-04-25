class ChangeNameType < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :name, :string
  end
end
