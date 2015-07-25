class WikiPolicy < ApplicationPolicy

  def leave_collaboration?
    record.collaborators.pluck(:user_id).include? user.id
  end

  def set_private?
    user.role == "admin" || user.role == "premium"
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user,scope)
      @user = user
      @scope = scope
    end

    def resolve
      wikis = []
      all_wikis = scope.all

      if user.admin?
        wikis = scope.all     #If user is admin, show them everything
      elsif user.premium?
        all_wikis.each do |wiki|
          if wiki.private == false || wiki.users.include?(user)
            wikis << wiki     #If the wiki is public, or the user is the author, or the user is a collaborator, show the wiki
          end
        end
      else
        all_wikis.each do |wiki|
          if wiki.private? == false || wiki.users.include?(user)
            wikis << wiki
          end
        end
      end

      wikis     #Return the Wikis array
    end
  end
end
