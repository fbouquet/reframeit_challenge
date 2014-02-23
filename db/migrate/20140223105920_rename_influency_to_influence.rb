class RenameInfluencyToInfluence < ActiveRecord::Migration
  def change
	rename_column :users, :influency, :influence
  end
end
