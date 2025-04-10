class PolicyNumber

  # @param rows [Array<String>]
  def self.from_rows(rows:)
    new(rows:)
  end

  # @param rows [Array<String>]
  def initialize(rows:)
    @rows = rows
  end

  # @return [Array<Array[String]>]
  def digits
    @rows.map { |row| row.scan(/.{1,3}/) } => [first, second, third]

    first.map.with_index { |digit, idx| [digit, second[idx], third[idx]] }
  end

  def close_digits
  end
end