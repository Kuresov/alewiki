class Wiki < ActiveRecord::Base
  has_many :collaborators
  has_many :users, through: :collaborators
  before_save :default_values

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true

  private

  def default_values
    self.private ||= false
  end
end
