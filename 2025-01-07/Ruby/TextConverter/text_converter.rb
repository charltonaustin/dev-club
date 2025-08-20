require 'cgi'

class UnicodeFileToHtmlTextConverter
  attr_reader :full_path_to_file
  
  def initialize(full_path_to_file)
    @full_path_to_file = full_path_to_file
  end

  # This method does too much
  def convert_to_html
    File.open(@full_path_to_file).readlines.map do |line|
      clean_line(line)
    end.join("")
  end

  private

  def clean_line(line)
    CGI.escapeHTML(line.strip) + "<br />"
  end
end
