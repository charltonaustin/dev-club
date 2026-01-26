require_relative "../lib/policy_number"
require_relative "../lib/constants"

describe PolicyNumber do
  let(:basic_numbers) {
    [
      '    _  _     _  _  _  _  _ ',
      '  | _| _||_||_ |_   ||_||_|',
      '  ||_  _|  | _||_|  ||_| _|',
    ]
  }

  let(:all_zeros) {
    [
      ' _  _  _  _  _  _  _  _  _ ',
      '| || || || || || || || || |',
      '|_||_||_||_||_||_||_||_||_|',
    ]
  }

  subject { described_class.from_rows(rows:) }

  context "parsing" do
    context "basic digits" do
      let(:rows) { basic_numbers }

      it {
        expect(subject.digit_values).to eq [
          Constants::DIGITS[1],
          Constants::DIGITS[2],
          Constants::DIGITS[3],
          Constants::DIGITS[4],
          Constants::DIGITS[5],
          Constants::DIGITS[6],
          Constants::DIGITS[7],
          Constants::DIGITS[8],
          Constants::DIGITS[9]
        ]
      }
    end

    context "all zeros" do
      let(:rows) { all_zeros }

      it { expect(subject.digit_values).to eq [
        Constants::DIGITS[0],
        Constants::DIGITS[0],
        Constants::DIGITS[0],
        Constants::DIGITS[0],
        Constants::DIGITS[0],
        Constants::DIGITS[0],
        Constants::DIGITS[0],
        Constants::DIGITS[0],
        Constants::DIGITS[0]
      ] }
    end
  end

  context "close_digits" do
    let(:rows) { all_zeros }

    it { expect(subject.close_digits).to eq [[0, 8], [0, 8], [0, 8], [0, 8], [0, 8], [0, 8], [0, 8], [0, 8], [0, 8]] }

    context "with illegible digit" do
      let(:rows) {
        [
          '    _  _  _  _  _  _  _  _ ',
          '| || || || || || || || || |',
          '|_||_||_||_||_||_||_||_||_|',

        ]
      }

      it { expect(subject.close_digits).to eq [[0], [0, 8], [0, 8], [0, 8], [0, 8], [0, 8], [0, 8], [0, 8], [0, 8]] }
    end
  end
end
