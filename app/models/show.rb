class Show < ApplicationRecord
  include Rails.application.routes.url_helpers

  mount_uploader :pic, ShowPicUploader

  resourcify

  # has_and_belongs_to_many :users, join_table: :hosts_shows
  has_many :podcasts
  has_many :show_memberships
  has_many :users, through: :show_memberships

  accepts_nested_attributes_for :show_memberships, :allow_destroy => true

  validates_presence_of :title, :description
  validates :title, uniqueness: true
  validates :slug, uniqueness: true

  # For friendlier URLs, use the title of the show instead of its id
  extend FriendlyId
  friendly_id :title, use: :slugged


  def broadcast_times
    day_times = []
    current_schedule = Schedule.current

    return if current_schedule.nil?

    current_schedule.assignments.each do |assignment|
      if assignment.show.id == self.id
        day_time = {}
        day_time[:day] = assignment.day_name
        day_time[:start] = assignment.start_time.strftime('%H:%M')
        day_time[:end] = assignment.end_time.strftime('%H:%M')

        day_times << day_time
      end
    end

    # TODO: change this to allow multiple broadcast times to be returned. But
    # careful, will break a few things (expecting a single result to be returned)
    # like broadcast time labels. Sort them out first
    day_times.first

  end


  def self.active
    # TODO: remove this line and make this a daily task
    Schedule.check_current

    # TODO: Make this query less hideous
    all = Show.all
    active = []

    all.each do |show|
      active << show if not show.broadcast_times.nil?
    end

    active
  end

  def link
    Rails.root.join(shows_path(self))
  end

  def self.of_user(user)
    ShowMembership.where(user_id: user.id).map(&:show)
  end

  def check_broadcast_time(start_time, end_time=nil)

    if (not end_time.nil?) and (end_time <= start_time)
      return 'The end time should come after the start time'
    end

    if Time.now.to_i >= start_time
      return 'The past is past. Please enquiry about the future'
    end

    schedule = Schedule.for_time(start_time)
    if schedule.nil?
      return 'No schedule information for this date'
    end

    unless schedule.show_valid_for_time?(self, start_time, end_time)
      'The show has not been allocated this time'
    else
      'ok'
    end

  end

end
