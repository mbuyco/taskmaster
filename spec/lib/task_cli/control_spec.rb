# frozen_string_literal: true

require './lib/task_cli/control'
require './lib/task'

RSpec.describe TaskMaster::TaskCLI::Control do
  context '#initialize' do
    it 'initialize a taskmaster cli control with given command and arguments' do
      control = described_class.new(:list)

      expect(control.instance_variable_get(:@command)).to eq(:list)
      expect(control.instance_variable_get(:@args)).to eq([])
    end
  end

  context '#list' do
    it 'should render ascii table of tasks' do
      allow(TaskMaster::Task).to receive(:list).and_return([])
      expect(TaskMaster::Task).to receive(:list)

      control = described_class.new(:list)
      control.run
    end
  end

  context '#run' do
    it 'should execute command if valid' do
      control = described_class.new(:list)
      expect(control).to receive(:send).with(:list)

      control.run
    end

    it 'should not execute command if not valid' do
      control = described_class.new(:unknown_command)
      expect(control).not_to receive(:send)

      control.run
    end
  end
end
