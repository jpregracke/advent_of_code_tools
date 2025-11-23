class Solution
  def initialize(input = :full)
    if input == :full
      @expected_results = self.class::DayConfig::EXPECTED_EXAMPLE_RESULTS[:full]
      @input = full_input
    else
      @expected_results = self.class::DayConfig::EXPECTED_EXAMPLE_RESULTS[:example]
      @input = example_input
    end
  end

  def run(part = :both)
    results = {}
    part = part.to_s

    if part == 'both' || part == 'part1'
      results[:part1] = run_part(:part1)
    end

    if part == 'both' || part == 'part2'
      results[:part2] = run_part(:part2)
    end

    results
  end

  def run_part(part)
    {}.tap do |result_hash|
      input_method = "#{part}_input"
      input = send(input_method, @input[part])
      result = send(part, input)

      if result == :not_implemented
        result_hash[:not_implemented] = true
      else
        result_hash[:result] = result
        result_hash[:correct] = result == @expected_results[part]
        result_hash[:expected_result] = @expected_results[part]
      end
    end
  end

  private

  def full_input
    lines = File.readlines(input_file_location).map(&:chomp)
    { part1: lines, part2: lines }
  end

  def example_input
    {
      part1: self.class::DayConfig::EXAMPLE_DATA_PART1.split("\n").map(&:chomp),
      part2: self.class::DayConfig::EXAMPLE_DATA_PART2.split("\n").map(&:chomp)
    }
  end

  def input_file_location
    AOC_SOLUTIONS_DIR.join(year.to_s, "day#{day}", 'input.txt')
  end

  def year
    self.class::DayConfig::YEAR
  end

  def day
    self.class::DayConfig::DAY
  end

  def parse_input(lines)
    lines
  end

  def part1_input(lines)
    @part1_input ||= parse_input(lines)
  end

  def part2_input(lines)
    @part2_input ||= parse_input(lines)
  end
end
