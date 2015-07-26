class WikiPolicy < ApplicationPolicy

  def leave_collaboration?
    if user
      record.collaborators.pluck(:user_id).include? user.id
    end
  end

  def set_private?
    user.admin? || user.premium?
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

      if user.nil?
        all_wikis.each do |wiki|
          if wiki.private? == false
            wikis << wiki
          end
        end
      elsif user.admin?
        wikis = scope.all     #If user is admin, show them everything
      elsif user.premium?
        all_wikis.each do |wiki|
          if wiki.private == false || wiki.users.include?(user)
            wikis << wiki     #If the wiki is public, or the user is the author, or the user is a collaborator, show the wiki
          end
        end
      end

      wikis     #Return the Wikis array
    end
  end
end
