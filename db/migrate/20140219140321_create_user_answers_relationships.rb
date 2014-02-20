class CreateUserAnswersRelationships < ActiveRecord::Migration
  def change
    create_table :user_answers_relationships do |t|
      t.integer :user_id
      t.integer :answer_id

      t.timestamps
    end
    add_index :user_answers_relationships, :user_id
    add_index :user_answers_relationships, :answer_id
    add_index :user_answers_relationships, [:user_id, :answer_id], unique: true
  end
end
