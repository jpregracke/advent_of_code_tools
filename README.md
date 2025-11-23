# Advent of Code Automation
A set of tools for the yearly [Advent of Code](https://adventofcode.com/) to automate the bootstrapping of each day's solution files and running of single or multiple solutions.

## Features

 - Initialize a day's boilerplate by downloading your personal input file, creating a set of solution files from templates, and outputting the problem text to the console.
 - Run today's (if available), a particular day's, a whole year's, or all available solution(s). There are options for running a single day's solution with either your personal input or an example input, and to run either part 1 or part 2 in isolation.
 - Details output when running solutions including the produced solution value, the expected solution value when the produced solution is incorrect (when available), and the runtimes of each part, each day, and all run solutions. The details also alert when a solution file isn't available for a particular day, and when a solution for a part hasn't been implemented.

## How To Use
### Installation

### Configuration
Once your ruby environment is set up, copy the file `config.example.yml` to `config.yml`. Edit the file to your liking. The only value that you need to change is `session`, which you need to set to your AoC session cookie. All requests to the Advent of Code website will use this cookie value. The other options available are:

 - **`solutions_base_dir`** - The directory relative to the root of the repo where solution files will be stored. Within this directory, each year will have its own subdirectory, followed by day subdirectories, containing each day's solution files. The default directory, `solutions` is ignored by git.
 - **`console_line_length`** - The maximum length of lines in the console output before wrapping. This is mostly used when printing out the problem description during day initialization. Set this value to `0` or `null` to disable this feature.
 - **`solutions_template_directory`** - The source directory (in `templates/`) of the templates to use when initializing a day's solution. See the section [Template Customization](#template_customization) for details.

### Operation
#### Running Commands
All commands are run using the `rake` utility. Arguments are positional, and supplied by listing them, comma separated, in square brackets. For example: `rake aoc:init_day[1,2024]` will execute the `aoc:init_day` task with the parameters 1 and 2024.

In general, for commands that take day and year parameters, where the day is the puzzle day in December, 1-25 for 2015-2024, and 1-12 after. If both are excluded, the task will attempt to use today, and if only the year is excluded, it will default to the current year. In either case, if they aren't valid AoC problem days, the command will fail. The "current day" is the current day in the US/East timezone, as the new puzzles are released at midnight on the East coast.

Some of the solution execution commands also take an optional `part` parameter. This can be set to `both` (the default), `part1`, or `part2`, which will attempt both solution parts, just part 1, or just part 2 respectively.

#### Day Initialization Command
The following command will initialize the specified day, downloading your personal input file and creating the empty solution files. If a file already exists, it will _not_ be overwritten, but a notice will be printed out.
```rake aoc:init_day[DAY,YEAR]```

#### Solution Execution
There are 6 ways of running solutions, one for a single day with 

**Running "today's" solution**
```rake aoc:today[PART]``` 
This option is only available during the active run of Advent of Code, and will run the current day's solution. With the optional PART argument, it will run only the specified part.

**Running "today's" solution with example data**
```rake aoc:today_example[PART]``` 
This is the same as the above, but using the example data defined in the solution file instead of your input data.

**Running a specific day's solution**
```rake aoc:day[DAY,YEAR,PART]``` 
This will run the specified day's solution. As with the today command, with the optional PART argument, it will run only the specified part.

**Running a specific day's solution with example data**
```rake aoc:day_example[DAY,YEAR,PART]``` 
This is the same as the above, but using the example data defined in the solution file instead of your input data.

**Running an entire year's solutions**
```rake aoc:year[YEAR]```
This will run all available solutions for the specified year, or the current year if the year argument is excluded.

**Running an entire year's solutions**
```rake aoc:all```
```rake aoc```
```rake```
All of the above commands will run all available solutions for all years.

For both the year and all commands, all possible solution days are attempted.

## Default Template
The default template for ruby solutions includes a configuration module, which has placeholders for the example data provided in the problem description, and expected results for both the examples and your own personal input data. The only one of these that is required is the example data, and then only if you wish to run your solutions against data with known result values. Otherwise, if these aren't set, everything will still work.

Obviously, you won't know the correct results for your data until you've already solve that day, but it can be good to record your answers if you want to improve your solution at all.

## <a name="template_customization"></a>Template Customization
If you want change the boilerplate solution file or files, you can edit the files in the `templates` directory. A subdirectory in this directory can be configured as the template source by adjusting the `solutions_template_directory` value in `config.yml`. The name of the directory has no meaning, it is simply a way to organize multiple sets of templates.

Every file in the subdirectory will be copied to the solution day's directory, with the same directory structure. File and directory names are used as is, with the exception of replacing `YEAR` and `DAY` in filenames and directory with the solution's year and day respectively.

Files with the `erb` extension are processed as ruby ERB files, with the values `year` and `day` available. The `.erb` extension will be removed from the output file name.

## Using Other Languages
Due to the nature of the tool, and the fact that the solutions are loaded into the same process as the tool, running solutions is currently only possible for those written in ruby. However, the day initialization, by nature of simply creating boilerplate files using the configured template files ([see above](#template_customization)), this tool can be used to create those files for any language. The templates just need to be written for the alternate language.
