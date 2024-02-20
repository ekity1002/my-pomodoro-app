class RemoveDescriptionFromProjects < ActiveRecord::Migration[7.1]
  def change
    remove_column :projects, :description, :text
  end
end
