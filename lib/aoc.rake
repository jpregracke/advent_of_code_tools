namespace :aoc do
  desc 'Run all available solutions'
  task :default do
    Runner.run_all
  end

  desc 'Run Advent of Code solutions for today, optionally specifying part. Usage: rake aoc:today[part]'
  task :today, [:part] do |t, args|
    unless Runner.run_today(part: args.part || 'both')
      exit 1
    end
  end

  desc 'Run Advent of Code solutions for today with example data, optionally specifying part. Usage: rake aoc:today_example[part]'
  task :today_example, [:part] do |t, args|
    unless Runner.run_today(input: :example, part: args.part || 'both')
      exit 1
    end
  end

  desc 'Run Advent of Code solutions for a specific year, day, and part. Usage: rake aoc:day[day,year,part]'
  task :day, [:day, :year, :part] do |t, args|
    unless Runner.run_day(year: args.year, day: args.day, part: args.part || 'both')
      exit 1
    end
  end

  desc 'Run Advent of Code solutions for a specific year, day, and part, with example data. Usage: rake aoc:day_exmaple[day,year,part]'
  task :day_example, [:day, :year, :part] do |t, args|
    unless Runner.run_day(year: args.year, day: args.day, input: :example, part: args.part || 'both')
      exit 1
    end
  end

  desc 'Run Advent of Code all available solutions for a specific year. Usage: rake aoc:year[year]'
  task :year, [:year] do |t, args|
    unless Runner.run_year(year: args.year)
      exit 1
    end
  end

  desc 'Run Advent of Code all available solutions. Usage: rake aoc:all'
  task :all do |t, args|
    unless Runner.run_all
      exit 1
    end
  end

  desc 'Initialize a new Advent of Code day. Usage: rake aoc:init_day[day,year]'
  task :init_day, [:day, :year] do |t, args|
    unless DayInit.init_day(args.year, args.day)
      exit 1
    end
  end
end

task aoc: 'aoc:all'
