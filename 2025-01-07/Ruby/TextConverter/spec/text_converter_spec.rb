require_relative "../text_converter"
describe UnicodeFileToHtmlTextConverter do
  context "#full_path_to_file" do
    it "returns expected value" do
      path = double("test path")

      converter = described_class.new(path)

      expect(converter.full_path_to_file).to eq(path)
    end
  end

  context "#convert_to_html" do
    it "returns expected value" do
      # puts Dir.pwd
      converter = described_class.new("TextConverter/spec/fixture.txt")

      expect(converter.convert_to_html).to eq("&gt;test&lt;<br />")
    end
  end
end
