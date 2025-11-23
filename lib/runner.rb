require 'boot'

class Runner
  VALID_PARTS = %w[part1 part2 both].freeze  

  def self.run_today(part: :both, output: ConsolePrinter.new, input: :full)
    run_day(year: nil, day: 'today', part:, output:, input:)
  end

  def self.run_day(year:, day:, part: :both, output: ConsolePrinter.new, input: :full)
    (year, day) = VALID_DAYS.discover_year_day(year, day)

    if VALID_DAYS.last_error
      output.print_error "Error: #{VALID_DAYS.last_error}"
      output.print "\n"
      return false
    end

    unless VALID_PARTS.include?(part.to_s)
      output.print_error "Error: Part must be one of #{VALID_PARTS.join(', ')}."
      output.print "\n"
      return false
    end

    new(year:, day:, part:, output:, input:).run
  end

  def self.run_year(year: :current, output: ConsolePrinter.new)
    if year == :current
      year = TODAY.year
    end

    (year, error) = VALID_DAYS.discover_year(year)

    if error
      output.print_error "Error: #{error}"
      output.print "\n"
      return false
    end

    run_time = Utils.timing do
      VALID_DAYS.valid_days
                .select { |y, _| y == year }
                .each { |_, day| new(year:, day:, output:).run }
    end
    output.print_success "\nCompleted Advent of Code #{year} in #{'%.3f' % run_time} seconds.\n"
  end

  def self.run_all(output: ConsolePrinter.new)
    run_time = Utils.timing do
      VALID_DAYS.valid_days.each do |year, day|
        new(year:, day:, output:).run
      end
    end
    output.print_success "\nCompleted all Advent of Code problems in #{'%.3f' % run_time} seconds.\n"
  end

  def initialize(year:, day:, part: :both, output: ConsolePrinter.new, input: :full)
    @year = year
    @day = day
    @part = part.to_s
    @output = output
    @input = input
  end

  def run
    solution_class = load_day(@year, @day)
    if solution_class
      parts = @part == 'both' ? [:part1, :part2] : [@part.to_sym]
      solution = solution_class.new(@input)

      @output.print_success "AoC #{@year} Day #{@day}\n"

      run_time = Utils.timing do
        parts.each do |part|
          result = nil
          part_run_time = Utils.timing do
            result = solution.run_part(part)
          end

          part_number = part.to_s.sub('part', '')

          if result[:not_implemented]
            @output.print_warning("  Part #{part_number}: Not yet implemented.\n")
          else
            match_mark =
              if result[:expected_result]
                if result[:correct] == true
                  @output.format_success('✓')
                else
                  @output.format_error("✗ / expected: #{result[:expected_result]}")
                end
              else
                @output.format_warning('?')
              end
  
            @output.print "  Part #{part_number}: #{result[:result]} [#{match_mark}] (took #{'%.3f' % part_run_time} seconds)\n"
          end  
        end
      end

      @output.print "  Day took #{'%.3f' % run_time} seconds total\n"
      true
    else
      @output.print_error("Solution for #{@year} Day #{@day} not found.\n")
      false
    end    
  end

  private

  def load_day(year, day)
    solution_file = AOC_SOLUTIONS_DIR.join(year.to_s, "day#{day}", 'solution.rb')
    if File.exist?(solution_file)
      require solution_file
      Object.const_get("AoC#{year}::Day#{day}")
    end
  end
end
