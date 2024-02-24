class Task < ApplicationRecord
  validates :title, presence: true
  validate :due_date_cannot_be_in_the_past

  belongs_to :project, optional: true
  has_many :task_tags
  has_many :tags, through: :task_tags

  enum status: { incomplete: false, complete: true }

  private

  def due_date_cannot_be_in_the_past
    if due_date.present? && due_date < Date.today
      errors.add(:due_date, "cant't be in the past")
    end
  end
end

