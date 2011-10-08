module ApplicationHelper

  def example(options={}, &block)
    out = render :partial => 'examples/header', :locals => {:options => options}
    out << capture(&block)
    out << (render :partial => 'examples/footer', :locals => {:options => options})
    out
  end

  def navigation()
    out = ""
    out << "<br /><br />"
    out << raw(link_to(t("Previous"), page_parts_path(params[:page].to_i - 1)))
    out << "&nbsp;&nbsp;"
    out << raw(link_to(t("Page") + " " + params[:page], ""))
    out << "&nbsp;&nbsp"
    out << raw(link_to(t("Next"), page_parts_path(params[:page].to_i + 1)))
    out << "<br /><br />"
  end

  def controls(param)
    content_tag(:div, content_tag(:span, t(param)), :class => "controls-sprite controls-#{param.downcase}")
  end

end
