class CreateUserPollRelationships < ActiveRecord::Migration
  def change
    create_table :user_poll_relationships do |t|
      t.integer :user_id
      t.integer :poll_id

      t.timestamps
    end
    add_index :user_poll_relationships, :user_id
    add_index :user_poll_relationships, :poll_id
    add_index :user_poll_relationships, [:user_id, :poll_id], unique: true
  end
end
