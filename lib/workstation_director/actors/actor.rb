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
      cmd_errored = false
      Open3.popen3(cmd) do |_, stdout, stderr, thread|
        watch_stdout = Thread.new do
          until (output_line = stdout.gets).nil? do
            stdout.puts output_line
          end
        end

        watch_stderr = Thread.new do
          until (output_line = stderr.gets).nil? do
            stderr.puts output_line
            cmd_errored = true
          end
        end

        thread.join
        watch_stdout.join
        watch_stderr.join
      end
      raise CommandError.new("Error when running '#{cmd}'") if cmd_errored
      true
    end

  end
end

