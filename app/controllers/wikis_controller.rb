class WikisController < ApplicationController
  def index
    if current_user
      @wikis = policy_scope(Wiki)
    else
      @wikis = Wiki.where(private: false)
    end
  end

  def show
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    @emails = @wiki.users.pluck(:email)
  end

  def collab
    @wikis = current_user.wikis
    authorize @wikis
  end

    def add_collaborator
      @wiki = Wiki.find(params[:id])
      @collab = @wiki.collaborators.new
      
      if User.where(email: params[:collaborator_email]).blank?
        flash[:error] = "That email does not exist."
        redirect_to edit_wiki_path and return
      else
        @user_id = User.where(email: params[:collaborator_email]).first.id
      end
      
      if @wiki.collaborators.where(user_id: @user_id).blank?
        @collab = @wiki.collaborators.build(user_id: @user_id)
      else
        flash[:error] = "That user is already a collaborator for this wiki"
        redirect_to edit_wiki_path and return
      end

      if @collab.save
        flash[:notice] = "#{params[:collaborator_email]} has been added as a collaborator to the wiki."
        redirect_to @wiki
      else
        flash[:error] = "There was an error adding the collaborator. Please try again."
        render :edit
      end
    end

    def leave_collaboration
      @wiki = Wiki.find(params[:id])
      @collab = Collaborator.find_by(user_id: current_user.id, wiki_id: @wiki.id)
      authorize @wiki
      
      if @collab.blank?
        flash[:error] = "Your email was not found to be a part of this collaboration."
        redirect_to @wiki
      else
        @collab.delete
        flash[:notice] = "Your collaboration on this wiki has been removed."
        redirect_to @wiki
      end
    end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

    def create
      @wiki = current_user.wikis.build(params.require(:wiki).permit(:title, :body, :private))
      authorize @wiki

      if @wiki.save
        flash[:notice] = "#{@wiki.title} saved!"
        redirect_to @wiki
      else
        flash[:error] = "There was a problem saving your article. Please try again."
        render :new
      end
    end

  def edit
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

    def update
      @wiki = Wiki.find(params[:id])
      authorize @wiki

      if @wiki.update_attributes(params.require(:wiki).permit(:title, :body, :private))
        flash[:notice] = "#{@wiki.title} saved!"
        redirect_to @wiki
      else
        flash[:error] = "There was a problem saving your article. Please try again."
        render :edit
      end
    end

    def destroy
      @wiki = Wiki.find(params[:id])
      authorize @wiki

      if @wiki.destroy
        flash[:notice] = "#{@wiki.name} has been deleted."
        redirect_to wikis_path
      else
        flash[:error] = "There was a problem deleting your article. Please try again."
        render :edit
      end
    end
end
