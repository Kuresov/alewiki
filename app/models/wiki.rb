class Wiki < ActiveRecord::Base
  belongs_to :user

  scope :visible, -> (user) { user && (user.role == 'admin' || user.role == 'premium') ? all : where(private: false) }
end
