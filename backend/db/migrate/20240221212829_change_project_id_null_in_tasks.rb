class ChangeProjectIdNullInTasks < ActiveRecord::Migration[7.1]
  def up
    change_column_null :tasks, :project_id, true
  end

  def down
    change_column_null :tasks, :project_id, false
  end
end
