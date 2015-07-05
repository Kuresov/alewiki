class WikiPolicy < ApplicationPolicy
  
  def show?
    record.private == false || user.role == 'admin' || user.role == 'premium'
  end
end
