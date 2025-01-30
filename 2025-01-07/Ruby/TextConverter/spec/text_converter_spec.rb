require_relative '../text_converter'

describe UnicodeFileToHtmlTextConverter do
  describe "#convert_to_html" do
    let(:file) { instance_double(File) }
    let(:file_path) { "foo/bar" }

    before { allow(File).to receive(:open).with(file_path).and_return(file) }

    it "inserts a break tag after each line" do
      expect(file).to receive(:each_line).and_yield("foo")

      converter = UnicodeFileToHtmlTextConverter.new(file_path)
      expect(converter.convert_to_html).to eq("foo<br />")
    end

    it "strips whitespace off of each line" do
      expect(file).to receive(:each_line).and_yield(" foo \t")

      converter = UnicodeFileToHtmlTextConverter.new(file_path)
      expect(converter.convert_to_html).to eq("foo<br />")
    end

    it "escapes HTML characters" do
      expect(file).to receive(:each_line).and_yield("<p>foo</p>")
      expect(CGI).to receive(:escapeHTML).with("<p>foo</p>").and_call_original

      converter = UnicodeFileToHtmlTextConverter.new(file_path)
      expect(converter.convert_to_html).to eq("&lt;p&gt;foo&lt;/p&gt;<br />")
    end

    it "works with multiline files" do
      expect(file).to receive(:each_line).and_yield("foo").and_yield("bar")

      converter = UnicodeFileToHtmlTextConverter.new(file_path)
      expect(converter.convert_to_html).to eq("foo<br />bar<br />")
    end
  end

  describe "#full_path_to_file" do
    it "executes correctly" do
      converter = UnicodeFileToHtmlTextConverter.new("foo")

      expect(converter.full_path_to_file).to eq("foo")
    end
  end
end

describe PlainTextFileReader do
  describe "#each_line" do
    let(:file) { instance_double(File) }
    let(:file_path) { "foo/bar" }

    before { allow(File).to receive(:open).with(file_path).and_return(file) }

    it "yields each line of the file" do
      expect(file).to receive(:each_line).and_yield("foo").and_yield("bar")

      reader = PlainTextFileReader.new(file_path)
      lines = []
      reader.each_line { |line| lines << line }

      expect(lines).to eq(%w[foo bar])
    end
  end
end
