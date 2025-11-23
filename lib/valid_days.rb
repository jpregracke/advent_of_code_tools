class ValidDays
  MAX_DAY = {
    2015 => 25,
    2016 => 25,
    2017 => 25,
    2018 => 25,
    2019 => 25,
    2020 => 25,
    2021 => 25,
    2022 => 25,
    2023 => 25,
    2024 => 25,
    2025 => 12
  }

  attr_reader :last_error

  def initialize
    @last_error = nil
  end

  def valid_days
    @valid_days ||= MAX_DAY.reduce([]) do |days, (year, max_day)|
      if year < TODAY.year
        1.upto(max_day) do |day|
          days << [year, day]
        end
      elsif year == TODAY.year && TODAY.month == 12
        1.upto([TODAY.day, max_day].min) do |day|
          days << [year, day]
        end
      end
      days
    end
  end

  def valid_years
    @valid_years ||= valid_days.map(&:first).uniq
  end

  def valid_day?(year, day)
    valid_days.include?([year, day])
  end

  def valid_year?(year)
    valid_years.include?(year)
  end

  def discover_year_day(year, day)
    @last_error = nil
    year ||= TODAY.year
    day ||= 'today'

    if day == 'today'
      if TODAY.month != 12
        @last_error = "Day can only be set to 'today' in December."
        return [nil, nil]
      end
      year = TODAY.year
      day = TODAY.day
    else
      day = day.to_i
      year = year.to_i
    end

    if valid_day?(year, day)
      return [year, day]
    else
      @last_error = "#{year} day #{day} is not a valid AoC problem day."
      return [nil, nil]
    end
  end

  def discover_year(year)
    @last_error = nil

    year ||= :current
    
    if year == :current
      year = TODAY.year
    end
    year = year.to_i

    if MAX_DAY.key?(year)
      return year
    else
      @last_error = "#{year} is not a valid AoC year."
      return nil
    end
  end
end
