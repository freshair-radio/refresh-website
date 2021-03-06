class Show < ApplicationRecord
  include Rails.application.routes.url_helpers

  mount_uploader :pic, ShowPicUploader

  # has_and_belongs_to_many :users, join_table: :hosts_shows
  has_many :podcasts, dependent: :delete_all
  # https://stackoverflow.com/questions/16782990/rails-how-to-populate-parent-object-id-using-nested-attributes-for-child-obje
  has_many :show_memberships, dependent: :delete_all, :inverse_of => :show
  has_many :users, through: :show_memberships
  has_many :posts
  # belongs_to :team, class_name: 'User', foreign_key: 'hub_show_id'
  has_one :team, foreign_key: 'hub_show_id'

  accepts_nested_attributes_for :show_memberships, :allow_destroy => true

  validates_presence_of :title, :description
  validates :title, uniqueness: true
  validates :slug, uniqueness: true

  # For friendlier URLs, use the title of the show instead of its id
  extend FriendlyId
  friendly_id :title, use: :slugged

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  scope :by_title, -> { order(:title) }

  def broadcast_times
    day_times = []
    current_schedule = Schedule.current

    return if current_schedule.nil?

    assignment = current_schedule.assignments.where(show_id: self.id).first
    return if assignment.nil?

    day_time = {}
    day_time[:day] = assignment.day_name
    day_time[:start] = assignment.start_time.strftime('%H:%M')
    day_time[:end] = assignment.end_time.strftime('%H:%M')

    day_times << day_time


    # TODO: change this to allow multiple broadcast times to be returned. But
    # careful, will break a few things (expecting a single result to be returned)
    # like broadcast time labels. Sort them out first
    day_times.first

  end


  def self.active
    all = Show.all
    active = []

    all.each do |show|
      active << show if not show.broadcast_times.nil?
    end

    active
  end

  def link
    ENV['WEBSITE_HOME'] + show_path(self).to_s
  end

  def pic_uri
    unless self.pic.url.nil?
      ENV['WEBSITE_HOME'] + self.pic.resized.url.to_s
    end
  end

  def hub_show?
    !self.team.blank?
  end

  def self.hub_shows
    Team.all.map(&:hub_show).compact
  end

  def self.not_hub_shows
    (Show.all - Show.hub_shows).sort_by { |show| show.title }
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
