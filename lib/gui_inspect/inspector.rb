require 'tempfile'

module GUIInspect
  class Inspector
    attr_reader :error

    def initialize
    end

    private def run_applescript(script)
      file = Tempfile.new('gui_inspect')
      output = begin
        file.write(script)
        file.close
        `osascript #{file.path}`
      ensure
        file.unlink # Release the temporary script file
      end
      if output =~ /^Error/
        @error = output.chomp
        return nil
      end
      @error = nil
      output.gsub(/,\s+/,"\n")
    end

    def puts_applescript_results(script)
      output = run_applescript(script)
      if output
        puts output
      else
        warn @error
        exit 1
      end
      output
    end

    def processes
      get_processes_script = <<-END_OF_APPLESCRIPT
        try
          tell application "System Events"
            set listOfProcesses to (name of every process where background only is false)
          end tell
          listOfProcesses
        on error errMsg number errorNumber
          "Error: " & errMsg & " (#" & (errorNumber as text) & ")"
        end try
      END_OF_APPLESCRIPT
      puts_applescript_results(get_processes_script)
    end

    def elements(app)
      get_elements_script = <<-END_OF_APPLESCRIPT
        try
          tell application "#{app}"
            activate -- If nescessary, starts application. Gives it focus
          end tell
          delay 3
          tell application "System Events"
            set frontmostName to name of application process 1 whose frontmost is true
            tell application process frontmostName
              set uiElems to entire contents
            end tell
          end tell
          uiElems
        on error errMsg number errorNumber
          "Error: " & errMsg & " (#" & (errorNumber as text) & ")"
        end try
      END_OF_APPLESCRIPT
      puts_applescript_results(get_elements_script)
    end
  end
end
