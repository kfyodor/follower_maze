require 'spec_helper'

describe FollowerMaze::Config do
  subject { described_class }

  it 'responds to logger level' do
    expect(subject).to respond_to :logger_level
    expect(subject).to respond_to :logger_level=
    expect(subject.logger_level).to eq :info
  end

  it 'responds to logger output' do
    expect(subject).to respond_to :logger_output
    expect(subject).to respond_to :logger_output=
    expect(subject.logger_output).to eq $stdout
  end

  it 'responds to event source port' do
    expect(subject).to respond_to :event_source_port
    expect(subject).to respond_to :event_source_port=
    expect(subject.event_source_port).to eq 9090
  end

  it 'responds to event source host' do
    expect(subject).to respond_to :event_source_host
    expect(subject).to respond_to :event_source_host=
    expect(subject.event_source_host).to eq '0.0.0.0'
  end

  it 'responds to clients port' do
    expect(subject).to respond_to :clients_port
    expect(subject).to respond_to :clients_port=
  end

  it 'responds to clients host' do
    expect(subject).to respond_to :clients_host
    expect(subject).to respond_to :clients_host=
    expect(subject.clients_host).to eq '0.0.0.0'
  end
end