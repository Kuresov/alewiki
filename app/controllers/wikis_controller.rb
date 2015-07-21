class WikisController < ApplicationController
  def index
    if current_user
      @wikis = policy_scope(Wiki)
      authorize @wikis
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

      if User.where(params[:email])
        @user = User.where(params[:email])
      else
        flash[:error] = "That email does not exist."
        redirect_to :back
      end

      @collab = @wiki.collaborators.build(params.require(:wiki).permit(user_id: User.where(params[:email]).id)
      
      if @collab.save
        flash[:notice] = "#{@user.email} has been added as a collaborator to the wiki"
        redirect_to @wiki
      else
        flash[:error] = "There was an error adding the collaborator. Please try again."
        render :edit
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
