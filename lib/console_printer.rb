class ConsolePrinter
  RED = 91
  GREEN = 92
  YELLOW = 93

  def print(message, stream: STDOUT, wrap_words: false, column_width: CONFIG['console_line_length'])
    if wrap_words
      message = word_wrap(message, column_width)
    end
    stream.print message
  end

  def print_success(message)
    print(green(message), stream: STDOUT)
  end

  def print_warning(message)
    print(yellow(message), stream: STDERR)
  end

  def print_error(message)
    print(red(message), stream: STDERR)
  end

  def format_success(text)
    green(text)
  end

  def format_warning(text)
    yellow(text)
  end

  def format_error(text)
    red(text)
  end

  private

  def red(text)
    color_text(text, RED)
  end

  def green(text)
    color_text(text, GREEN)
  end

  def yellow(text)
    color_text(text, YELLOW)
  end

  def color_text(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def word_wrap(message, column_width)
    if column_width.to_i > 0
      pattern = /(.{1,#{column_width}})(?:[^\S\n]+\n?|\n*\Z|\n)|\n/    
      message.gsub(pattern, "\\1\n").chomp!("\n")
    else
      message
    end
  end
end
