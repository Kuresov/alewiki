class WikiPolicy < ApplicationPolicy

  class Scope
    attr_reader :user, :scope

    def initialize(user,scope)
      @user = user
      @scope = scope
    end

    def resolve
      wikis = []

      if user.role == 'admin'
        wikis = scope.all     #If user is admin, show them everything
      elsif user.role == 'premium'
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if wiki.public? || wiki.user == user || wiki.users.include?(user)
            wikis << wiki     #If the wiki is public, or the user is the author, or the user is a collaborator, show the wiki
          end
        end
      else
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if wiki.public? || wiki.users.include?(user)
            wikis << wiki     #If the user has a standard account, only show public or collaborated wikis.
          end
        end
      end

      wikis     #Return the Wikis array
    end
  end
end
