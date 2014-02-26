class CreateUserAnswersHistoryRelationships < ActiveRecord::Migration
  def change
    create_table :user_answers_histories do |t|
      t.integer :user_id
	    t.integer :answer_id

	    t.timestamps
    end

    add_index :user_answers_histories, :user_id
    add_index :user_answers_histories, :answer_id
    add_index :user_answers_histories, [:user_id, :answer_id], unique: true
  end
end
