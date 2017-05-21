class PagesController < ApplicationController

  def show
    @page = Page.friendly.find(params[:id])
    @sub_pages = @page.sub_pages.order(priority: :desc)
    @title = @page.title
    @nav_pages = @static_pages
  end
  
end
