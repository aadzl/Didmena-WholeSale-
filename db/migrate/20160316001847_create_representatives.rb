class CreateRepresentatives < ActiveRecord::Migration
  def change
    create_table :representatives do |t|	# Representatives too long; Reps maybe enough?!
      t.integer :company_id, null: false
      t.integer :user_id, null: false
      t.string :type, null: false		# Representative type: Agent - XO, Contact - OX, Both - XX
      t.text :comment

      t.timestamps null: false

      # t.check 'type IN ('XO', 'OX', 'XX')', name: 'reps_type_chk'
    end

    add_index :representatives, [:company_id, :user_id], :unique => true, name: :ui_reps
 
    add_foreign_key :representatives, :companies, on_delete: :cascade, name: :fk_reps_on_company_id
    add_index :representatives, [:company_id], name: :i_reps_on_company_id
 
    add_foreign_key :representatives, :users, on_delete: :cascade, name: :fk_reps_on_user_id
    add_index :representatives, [:user_id], name: :i_reps_on_user_id

  end
end
