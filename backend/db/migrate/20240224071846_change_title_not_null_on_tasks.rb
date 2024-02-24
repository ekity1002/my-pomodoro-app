class ChangeTitleNotNullOnTasks < ActiveRecord::Migration[7.1]
  def change
    change_column :tasks, :title, :string, null: false
  end
end
