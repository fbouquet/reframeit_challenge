class AddEndsatToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :ends_at, :datetime
  end
end
