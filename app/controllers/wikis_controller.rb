class WikisController < ApplicationController
  def index
    @wikis = Wiki.all
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
  end

    def create
      @wiki = current_user.wikis.build(params.require(:wiki).permit(:title, :body, :private))

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
  end

    def update
      @wiki = Wiki.find(params[:id])
      
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

      if @wiki.destroy
        flash[:notice] = "#{@wiki.name} has been deleted."
        redirect_to wikis_path
      else
        flash[:error] = "There was a problem deleting your article. Please try again."
      end
    end
end
