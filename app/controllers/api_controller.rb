class ApiController < ActionController::Base

  def get_messages
    redis = Redis.new
    # Messages will be an array of JSON strings. To parse these on the client side call
    # JSON.parse(...) on each element.
    # A one-liner might be (if `messages` is the returned value from the API call)
    # `messages = messages.map(JSON.parse)`
    # Caution: this returns the raw data submitted by the client, with no html escaping.
    #          If this will be included in HTML, make sure to escape it.
    messages = redis.lrange "messages", 0, 8    
    render json: messages
  end

  def submit_message
    redis = Redis.new
    redis.lpush "messages", {author: params[:author],
                             content: params[:content],
                             time: params[:time],
                             date: params[:date]}.to_json
    render json: {message: "Success"}
  end

  def set_broadcast_info
    # IP's allowed to make changes, localhost and the current studio windows PC
    # TODO: add new PC IP to the list (when it's set up)
    allowed = ["127.0.0.1", "129.215.245.82"]
    if allowed.include? request.remote_ip
      redis = Redis.new
      redis.set "broadcast_info_title", params[:title]
      redis.set "broadcast_info_status",params[:status]
      redis.set "broadcast_info_pic", params[:pic]
      redis.set "broadcast_info_slug", params[:slug]
      redis.set "broadcast_info_link", params[:link]
      render json: {message: "Success"}
    else
      render json: {message: "Unauthorised"}
    end
  end

  def get_broadcast_info
    redis = Redis.new
    title = redis.get "broadcast_info_title"
    status = redis.get "broadcast_info_status"
    pic = redis.get "broadcast_info_pic"
    slug = redis.get "broadcast_info_slug"
    link = redis.get "broadcast_info_link"
    title ||= "The best music from FreshAir.org.uk"
    status ||= "FreshSounds"
    # Don't give pic a default value, because the frontend can handle that (with a default src)
    # Slug and link are optional, so also don't need a default value
    render json: {title: title, status: status, pic: pic, slug: slug, link: link}
  end

  def shows_for_user
    @user = User.valid.find_by_email(params[:email])
    if @user.nil?
      render json: nil
    else
      @shows = @user.all_shows
      @shows = @shows.map do |s|
        {slug: s.slug, title: s.title, tag_line: s.tag_line, description: s.description, link: s.link, pic: s.pic_uri}
      end

      render json: @shows
    end
  end

  def current_schedule
    @current = Schedule.current

    if @current.nil?

      render json: nil
    else
      @response = {}
      WeekService.days_dic.each do |day, integer|
        @response[day.downcase.to_sym] = @current.assignments.where(day_of_week: integer).to_json(only: [:start_time, :end_time], methods: [:show_slug])
      end
      # TODO: still doesn't work for free schedules
      render json: @response
    end
  end

  def show_by_slug
    @show = Show.find_by_slug(params[:slug])
    if @show.nil?
      render json: nil
    else
      render json: {title: @show.title, tag_line: @show.tag_line, description: @show.description, link: @show.link, pic: @show.pic_uri}
    end
  end

  def all_shows
    @shows = Show.by_title
    @shows = @shows.map do |s|
      {slug: s.slug, title: s.title, tag_line: s.tag_line, description: s.description, link: s.link, pic: s.pic_uri}
    end
      render json: @shows
  end

  def check_broadcast_time
    @show = Show.find_by_slug(params[:slug])
    start_time = params[:start].to_i

    if @show.nil?
      response =  'No show matching slug'
    elsif params[:end].nil?
      response = @show.check_broadcast_time(start_time)
    else
      end_time = params[:end].to_i
      response = @show.check_broadcast_time(start_time, end_time)
    end

    render plain: response
  end

  def podcasts_by_show
    @show = Show.find_by_slug(params[:show_slug])
    @podcast_list = @show.podcasts.map do |podcast|
      {title: podcast.title, description: podcast.description, uri: podcast.uri, broadcast_date: podcast.broadcast_date}
    end
    render json: @podcast_list
  end

end
