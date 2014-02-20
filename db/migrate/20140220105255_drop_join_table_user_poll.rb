class DropJoinTableUserPoll < ActiveRecord::Migration
  def change
  	drop_join_table :users, :polls
  end
end
