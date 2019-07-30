class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_globals


  private

  def set_globals
    # We need to set these globally so that the sidebar and main nav can access
    # them from anywhere
    # Give them the name of a model (like @teams instead of @global_teams) and
    # ActiveAdmin will break in marvelous ways, as it includes this controller
    @upcoming_events = Event.upcoming
    @tweets = TwitterService.get_timeline
    @global_pages = Page.all.order(priority: :desc)
    @global_teams = Team.order(:display_order)
    @global_tags = Tag.post_types
  end
end
