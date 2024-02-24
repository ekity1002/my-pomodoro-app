class Task < ApplicationRecord
  validates :title, presence: true

  belongs_to :project, optional: true
  has_many :task_tags
  has_many :tags, through: :task_tags
  enum status: { incomplete: false, complete: true }
end

