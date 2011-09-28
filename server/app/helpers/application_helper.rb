module ApplicationHelper

  def example(options={}, &block)
    out = render :partial => 'examples/header', :locals => {:options => options}
    out << capture(&block)
    out << (render :partial => 'examples/footer', :locals => {:options => options})
    out
  end

  def controls(param)
    content_tag(:div, content_tag(:span, t(param)), :class => "controls-sprite controls-#{param.downcase}")
  end

end
