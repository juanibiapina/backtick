require "spec_helper"

RSpec.describe Backtick::Command do
  let(:command) { Backtick::Command.new }
  let(:cmd) { "command line" }
  let(:stdin) { double("stdin") }
  let(:stdout_and_err) { double("stdout_and_err") }
  let(:wait_thr) { double("wait_thr") }

  before do
    allow(Open3).to receive(:popen2e).with(cmd).and_yield(stdin, stdout_and_err, wait_thr)
    allow(stdout_and_err).to receive(:each).and_yield("line 1").and_yield("line 2")
  end

  context "command passes" do
    let(:success) { double("success status", success?: true, exitstatus: 0) }

    before do
      allow(wait_thr).to receive(:value).and_return(success)
    end

    it "runs a system command without a block" do
      command.run(cmd)
    end

    it "yields output lines with a block" do
      expect { |b| command.run(cmd, &b) }.to yield_successive_args("line 1", "line 2")
    end
  end

  context "command fails" do
    let(:failure) { double("failure status", success?: false, exitstatus: 1) }

    before do
      allow(wait_thr).to receive(:value).and_return(failure)
    end

    it "raises an exception" do
      expect { command.run(cmd) }.to raise_error(Backtick::Command::StatusError, "Command `#{cmd}` failed with exit status: #{1}")
    end
  end
end
