require "open3"

class Backtick::Command
  class StatusError < StandardError; end

  def self.run(cmd, &block)
    Backtick::Command.new.run(cmd, &block)
  end

  def run(cmd)
    Open3.popen2e(cmd) do |_, stdout_and_err, wait_thr|
      stdout_and_err.each do |line|
        yield line if block_given?
      end

      status = wait_thr.value
      raise StatusError, "Command `#{cmd}` failed with exit status: #{status.exitstatus}" unless status.success?
    end
  end
end
