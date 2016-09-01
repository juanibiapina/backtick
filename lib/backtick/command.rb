require "open3"

class Backtick::Command
  class StatusError < StandardError; end

  def self.run(cmd, &block)
    Backtick::Command.new.run(cmd, &block)
  end

  def run(cmd)
    Open3.popen2e(cmd) do |_, stdout_and_err, wait_thr|
      captured_output = []
      stdout_and_err.each do |line|
        captured_output << line

        yield line if block_given?
      end

      status = wait_thr.value

      if ! status.success?
        message = "Command `#{cmd}` failed with exit status: #{status.exitstatus}"
        if captured_output.empty?
          message += " and no output"
        else
          message += " and output:\n" + captured_output.join("")
        end
        raise StatusError, message
      end
    end
  end
end
