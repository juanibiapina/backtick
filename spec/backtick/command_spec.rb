require "spec_helper"

RSpec.describe Backtick::Command do
  let(:command) { Backtick::Command.new }
  let(:cmd) { "command line" }
  let(:stdin) { double("stdin") }
  let(:stdout_and_err) { double("stdout_and_err") }
  let(:wait_thr) { double("wait_thr") }

  before do
    allow(Open3).to receive(:popen2e).with(cmd).and_yield(stdin, stdout_and_err, wait_thr)
    allow(stdout_and_err).to receive(:each).and_yield("line 1\n").and_yield("line 2\n")
  end

  context "command passes" do
    let(:success) { double("success status", success?: true, exitstatus: 0) }

    before do
      allow(wait_thr).to receive(:value).and_return(success)
    end

    context "without a block" do
      it "runs a system command" do
        command.run(cmd)
      end
    end

    context "with a block" do
      it "yields output lines" do
        expect { |b| command.run(cmd, &b) }.to yield_successive_args("line 1\n", "line 2\n")
      end
    end
  end

  context "command fails" do
    let(:failure) { double("failure status", success?: false, exitstatus: 1) }

    before do
      allow(wait_thr).to receive(:value).and_return(failure)
    end

    context "with output" do
      it "raises an exception with output" do
        expect { command.run(cmd) }.to raise_error(Backtick::Command::StatusError, "Command `#{cmd}` failed with exit status: #{1} and output:\nline 1\nline 2\n")
      end
    end

    context "without output" do
      before do
        allow(stdout_and_err).to receive(:each)
      end

      it "raises an exception without output" do
        expect { |b| command.run(cmd, &b) }.to raise_error(Backtick::Command::StatusError, "Command `#{cmd}` failed with exit status: #{1} and no output")
      end
    end
  end
end
