module HtmlWriter

  def wrap_html_body(f)
    f.write("<html><body>\n")
    yield
    f.write("</body></html>\n")
  end

  def write_header(f, title, css)
    f.write("<head><meta http-equiv=Content-Type content=\"text/html; charset=utf-8\">\n")
    f.write("<title>#{title}</title>\n")
    css.each do |c|
      f.write("<link rel=\"stylesheet\" href=\"#{c}\" type=\"text/css\" />\n")
    end
    f.write("</head>\n")
  end

  def back_link_html(depth)
    <<END
<div class="backDiv">
<h3><a href="#{"../" * depth}ZJUerXTCer.html" class="backLink">Back to homepage</h3>
</div>
END
  end


end
