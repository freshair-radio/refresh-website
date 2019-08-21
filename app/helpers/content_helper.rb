require 'redcarpet'

module ContentHelper

  def rating(score)
    score = score.to_i
    result = ''
    unless !PostMetadatum.valid_rating?(score)
      result += '<div class="rating">'
      half_score = score / 2
      (1..half_score).each do
        result += '<i class="fa fa-star" aria-hidden="true"></i>'
      end
      if score.odd?
        result += '<i class="fa fa-star-half-o" aria-hidden="true"></i>'

        (half_score+2..5).each do
          result += '<i class="fa fa-star-o" aria-hidden="true"></i>'
        end

      else

        (half_score+1..5).each do
          result += '<i class="fa fa-star-o" aria-hidden="true"></i>'
        end

      end
      result += '</div>'
    end
    result
  end

  def markdown_toc(string)
    renderer = Redcarpet::Render::HTML_TOC.new()
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    markdown.render(string)
  end

  def markdown(string)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, with_toc_data: true)
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    markdown.render(string)
  end

  def accepted_tags
    %w(strong em b i p code pre tt samp kbd var sub
    sup dfn cite big small address hr br div span h1 h2 h3 h4 h5 h6 ul ol li dl dt dd abbr
    acronym a img blockquote del ins iframe table tr th td audio)
  end

  def accepted_attributes
    %w(href src width height alt cite datetime title class name xml:lang abbr style border cellpadding cellspacing target controls)
  end

end
