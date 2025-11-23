require 'erb'
require 'html2text'
require 'net/http'
require 'ostruct'

class DayInit
  DAY_URL = 'https://adventofcode.com/<YEAR>/day/<DAY>'

  Context = Struct.new(:year, :day) do
    def process_template(template)
      renderer = ERB.new(template, trim_mode: '-')
      renderer.result(binding)
    end
  end

  attr_reader :errors

  def self.init_day(year, day, output = ConsolePrinter.new)
    (year, day) = VALID_DAYS.discover_year_day(year, day)

    if VALID_DAYS.last_error
      output.print_error "Error: #{VALID_DAYS.last_error}"
      output.print "\n"
      return false
    end

    init = new(year, day, output)
    problem_description = init.call

    if init.errors.none?
      output.print_success "Successfully initialized Advent of Code #{year} Day #{day}."
      output.print "\n\n"
      output.print "Problem description for Advent of Code #{year} Day #{day}:"
      output.print "\n\n"
      output.print problem_description, wrap_words: true
      output.print "\n"
      return true
    else
      output.print_error "Errors encountered during initialization:"
      output.print "\n"
      init.errors.each do |error|
        output.print_error "- #{error}"
        output.print "\n"
      end
      return false
    end
  end

  def initialize(year, day, output = ConsolePrinter.new)
    @year = year
    @day = day
    @output = output
    @errors = []
    @context = Context.new(year, day)
  end

  def call
    @errors = []
    problem_description = nil
    begin
      download_input if @errors.empty?
      build_files if @errors.empty?
      problem_description = extract_problem_description if @errors.empty?
    rescue StandardError => e
      @errors << "Exception encountered: #{e.message}"
    end
    @errors.freeze
    problem_description
  end

  private

  def download_input
    dir_path = solution_dir
    file_path = dir_path.join('input.txt')
    if File.exist?(file_path)
      @output.print_warning "Not overwriting exisitng input file at #{file_path}."
      @output.print "\n\n"
      return
    end

    fetch_page(path: '/input', description: 'input data') do |input|
      File.write(file_path, input)
    end
  end

  def build_files(directory = AOC_SOLUTION_TEMPLATE_DIR)
    directory_path = solution_dir.join(directory.relative_path_from(AOC_SOLUTION_TEMPLATE_DIR))
    directory_path = directory_path.to_s.gsub(/YEAR/, @year.to_s).gsub(/DAY/, @day.to_s)
    FileUtils.mkdir_p(directory_path)

    directory.children.each do |entry|
      if entry.directory?
        build_files(entry)
      else
        process_template_file(entry)
      end
    end
  end

  def process_template_file(template_file)
    output_path = solution_dir.join(template_file.relative_path_from(AOC_SOLUTION_TEMPLATE_DIR)).to_s
    contents = File.read(template_file)
    if template_file.extname == '.erb'
      contents = @context.process_template(contents)
    end

    output_path = output_path .gsub(/YEAR/, @year.to_s)
                              .gsub(/DAY/, @day.to_s)
                              .gsub(/.erb\z/, '')

    if File.exist?(output_path)
      @output.print_warning "Not overwriting existing solution file at #{output_path}."
      @output.print "\n\n"
      return
    end
    File.write(output_path, contents)
  end

  def extract_problem_description
    fetch_page(description: 'problem page') do |page|
      html = page.encode('UTF-8', invalid: :replace, undef: :replace, replace: '', universal_newline: true).gsub(/\P{ASCII}/, '')
      parser = Nokogiri::HTML(html, nil, Encoding::UTF_8.to_s)
      html = parser.xpath('//article[@class="day-desc"]').to_s
      Html2Text.convert(html)
    end
  end

  def solution_dir
    @solution_dir ||= AOC_SOLUTIONS_DIR.join(@year.to_s, "day#{@day}").tap { |path| FileUtils.mkdir_p(path) }
  end

  def fetch_page(description:, path: '')
    uri = URI.parse(DAY_URL.gsub('<YEAR>', @year.to_s).gsub('<DAY>', @day.to_s) + path)
    result = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Get.new(uri)
      request['Cookie'] = "session=#{AOC_SESSION}"
      http.request(request)
    end

    if result.code == '200'
      yield result.body
    else
      @errors << "Failed to download #{description}: HTTP #{result.code} / #{result.body}"
    end
  end
end
