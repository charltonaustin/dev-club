require_relative '../text_converter'

describe UnicodeFileToHtmlTextConverter do
  context "#foo" do
    it "executes correctly" do
      converter = UnicodeFileToHtmlTextConverter.new("foo")

      expect(converter.full_path_to_file).to eq("foo")
    end
  end

  context "#convert_to_html" do
    it "converts a file to html" do
      converter = UnicodeFileToHtmlTextConverter.new("test.txt")

      expect(converter.convert_to_html).to eq("This is a test file.<br />")
    end

    it "converts a file to html" do
      converter = UnicodeFileToHtmlTextConverter.new("test_2.txt")

      expect(converter.convert_to_html).to eq("This is another test file.<br />This is another test file.<br />")
    end    
  end
end
