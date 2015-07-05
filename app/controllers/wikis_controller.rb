class WikisController < ApplicationController
  def index
    @wikis = Wiki.visible(current_user)
    authorize @wikis
  end

  def show
    @wiki = Wiki.find(params[:id])
    authorize @wiki
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
