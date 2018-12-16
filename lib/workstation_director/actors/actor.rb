require 'open3'

module WorkstationDirector
  class CommandError < StandardError; end

  class Actor
    def present?
      false
    end

    def install
      true
    end

    def setup
      true
    end

    def run_command(cmd)
      stdout, stderr, status = Open3.capture3(cmd)
      if status.exit_status != 0
        raise CommandError.new(stderr)
      else
        puts stdout if stdout
      end
      true
    end

  end
end

