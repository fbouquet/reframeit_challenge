class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :content
      t.integer :poll_id
      t.integer :correct_answer_id

      t.timestamps
    end
  end
end
