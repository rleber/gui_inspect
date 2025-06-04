require 'thor'
require_relative "gui_inspect/version"
require_relative "gui_inspect/inspector"

module GUIInspect
  class Error < StandardError; end
  class CLI < Thor
    package_name "gui_inspect"

    def self.exit_on_failure?
      false
    end

    # Display help with additional context
    def help(command = nil, subcommand: false)
      say <<~END_HELP
        gui_inspect 
        -----------
        Provides a set of tools for inspecting the GUI processes and elements of a MacOS GUI
        environment. This is useful as a tool to help design scripts for GUI automation.

      END_HELP
      super command, subcommand
    end

    # desc 'help', "Get help text"
    # def help
    #   puts caller.first.inspect
        
    #   app_name = File.basename(__FILE__)
    #   help_text = <<-END_HELP
    #     |  #{app_name}:
    #     |
    #     |  Gather information about the elements of the graphical user interface of an application
    #     |
    #     |  Usage:
    #     |    #{app_name} '<name of GUI app>'
    #     |
    #     |  #{app_name} gathers a lot of information about the named application and outputs it to
    #     |  the standard output. (Standard output may be redirected to a file using the usual '>'
    #     |  syntax.)
    #     |
    #     |  For best results, we recommend that you have the application you want to analyze already
    #     |  running and in the state that you want it. (For instance, displaying dialogs you're interested
    #     |  in.) Move quickly -- this script can only capture information while it is still displayed.
    #   END_HELP
    #   puts help_text.split("\n").map { |line| line[/^\s*\|\s\s(.*)$/, 1]}.join("\n")
    # end

    desc 'version', "Display version"
    def version
      puts GUIInspect.version
    end
    
    desc 'processes', "Show the active processes"
    long_desc <<-END_DESC
      Gather information about the processes currently running in the GUI.\x5
      \x5
      Produces a list of running processes on $stdout (which may be redirected using the 
      usual '>' syntax). \x5
      \x5
      Move quickly -- this script can only capture information about processes while they are still running.
    END_DESC

    def processes
      inspector = GUIInspect::Inspector.new
      inspector.processes
    end
        
    desc 'elements APPLICATION', "Show the UI elements"
    long_desc <<-END_DESC
      Gather information about the elements of the graphical user interface of an application.\x5
      \x5
      Gathers a lot of information about the named application and outputs it to
      the standard output. (Standard output may be redirected to a file using the usual '>'
      syntax.)\x5
      \x5
      For best results, we recommend that you have the application you want to analyze already
      running and in the state that you want it. (For instance, displaying dialogs you're interested
      in.)\x5
      \x5
      Move quickly -- this script can only capture information while it is still displayed.
    END_DESC
    def elements(application)
      inspector = GUIInspect::Inspector.new
      inspector.elements(application)
    end

    class << self
      def go(argv)
        GUIInspect::CLI.start(argv)
      end
    end
  end
end
