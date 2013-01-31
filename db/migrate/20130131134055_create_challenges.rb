class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :name
      t.string :description
      t.integer :difficulty
      t.integer :maximum_execution_time

      t.text :sample_setup
      t.string :sample_solution
      t.text :sample_output

      t.integer :creator_id
      t.boolean :active, :default => true

      t.timestamps
    end

    create_table :challenge_cases do |t|
      t.integer :challenge_id
      t.text :setup
      t.text :expected_output
      t.boolean :active, :default => true

      t.timestamps
    end

    create_table :solutions do |t|
      t.integer :user_id
      t.integer :challenge_id

      t.integer :submitted_at
      t.boolean :approved, :default => false

      t.text :code
      t.text :code_output
      t.datetime :ran_at

      t.boolean :success, :default => false
      t.text :display_output
      t.integer :score

      t.timestamps
    end
  end
end
