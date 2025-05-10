require 'cgi'

class UnicodeFileToHtmlTextConverter
  attr_reader :full_path_to_file
  
  def initialize(full_path_to_file, file_reader: PlainTextFileReader)
    @full_path_to_file = full_path_to_file
    @file_reader = file_reader || PlainTextFileReader.new(full_path_to_file)
  end

  def convert_to_html
    f = File.open(@full_path_to_file)
    html = ""
    f.each_line do |line|
      line = line.strip
      html << CGI.escapeHTML(line)
      html << "<br />"
    end

    return html
  end
end

class PlainTextFileReader
  def initialize(file_path)
    @file_path = file_path
  end

  def each_line
    file.each_line do |line|
      yield line
    end
  end

  private

  def file
    @file ||= File.open(@file_path)
  end
end
