require 'pathname'
require 'yaml'
require 'tzinfo'
require 'byebug'

AOC_ROOT = Pathname.new(File.expand_path("..", __dir__))
$LOAD_PATH.unshift AOC_ROOT.join("lib").to_s

require 'console_printer'
require 'day_init'
require 'runner'
require 'solution'
require 'utils'
require 'valid_days'

ENV["BUNDLER_GEMFILE"] ||= AOC_ROOT.join("Gemfile").to_s
require "bundler/setup"

config_file = AOC_ROOT.join("config.yml").to_s
if !File.exist?(config_file)
  puts "Missing config.yml file. Please create one based on config.example.yml"
  exit 1
end

begin
  CONFIG = YAML.load_file(config_file)
rescue Psych::SyntaxError => e
  puts "Error parsing config.yml: #{e.message}"
  exit 1
end

if !CONFIG["session"] || CONFIG["session"].empty?
  puts "Missing session value in config.yml. Please set your Advent of Code session cookie."
  exit 1
end
AOC_SESSION = CONFIG["session"]
AOC_SOLUTIONS_DIR = AOC_ROOT.join(CONFIG['solutions_base_dir'])
AOC_SOLUTION_TEMPLATE_DIR = AOC_ROOT.join('templates', CONFIG['solution_template_directory'])

AOC_TIMEZONE = TZInfo::Timezone.get('America/New_York')
TODAY = Time.now.localtime(AOC_TIMEZONE)

VALID_DAYS = ValidDays.new
