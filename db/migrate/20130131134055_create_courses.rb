class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
        
      t.timestamps
    end

    create_table :holes do |t|
      t.integer :course_id
      t.string :name
      t.text :description
      t.integer :par
      t.integer :maximum_execution_time

      t.text :sample_setup
      t.text :sample_solution
      t.text :sample_output

      t.integer :creator_id
      t.boolean :active, :default => true

      t.timestamps
    end

    create_table :test_cases do |t|
      t.integer :hole_id
      t.text :setup
      t.text :expected_output
      t.boolean :active, :default => true

      t.timestamps
    end

    create_table :solutions do |t|
      t.integer :user_id
      t.integer :hole_id

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
