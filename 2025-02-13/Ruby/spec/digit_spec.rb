require_relative "../lib/digit"
require_relative "../lib/constants"

describe Digit do
  let(:input_digit_segments) {
    [
      ' _ ',
      '| |',
      '|_|',
    ]
  }

  let(:compare_digit_segments) {
    [
      ' _ ',
      '|_|',
      '|_|',
    ]
  }

  subject { described_class.new(input_digit_segments) }

  context "distance_from_digit" do
    it "returns count of different characters" do
      compare_digit = Digit.new(compare_digit_segments)

      expect(subject.distance_from_digit(compare_digit)).to eq(1)
    end
  end
end
