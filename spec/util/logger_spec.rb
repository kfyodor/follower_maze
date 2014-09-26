require 'spec_helper'
require 'stringio'

describe FollowerMaze::Util::Logger do
  subject { described_class.new }
  let(:out) { StringIO.new }

  before(:each) do
    subject.logger_output = out
  end

  it 'initializes with config' do
    expect(subject.instance_variable_get(:@config)).to eq FollowerMaze::Config
  end

  it 'changes output' do
    expect(subject.logger_output).to eq out
  end

  context 'debug' do
    before(:each) do
      subject.logger_level = :debug
    end

    it 'prints debug message' do
      subject.debug("aaa")
      expect(out.string).to match /^debug:.+aaa$/
    end

    it 'prints info message' do
      subject.info("bbb")
      expect(out.string).to match /^info:.+bbb$/
    end

    it 'prints error message' do
      subject.error("ccc")
      expect(out.string).to match /^error:.+ccc$/
    end
  end

  context 'info' do
    before(:each) do
      subject.logger_level = :info
    end

    it 'doesnt print debug message' do
      subject.debug("aaa")
      expect(out.string).not_to match /^debug:.+aaa$/
    end

    it 'prints info message' do
      subject.info("bbb")
      expect(out.string).to match /^info:.+bbb$/
    end

    it 'prints error message' do
      subject.error("ccc")
      expect(out.string).to match /^error:.+ccc$/
    end
  end

  context 'error' do
    before(:each) do
      subject.logger_level = :error
    end

    it 'doesnt print debug message' do
      subject.debug("aaa")
      expect(out.string).not_to match /^debug:.+aaa$/
    end

    it 'doesnt print info message' do
      subject.info("bbb")
      expect(out.string).not_to match /^info:.+bbb$/
    end

    it 'prints error message' do
      subject.error("ccc")
      expect(out.string).to match /^error:.+ccc$/
    end
  end
end