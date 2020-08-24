# frozen_string_literal: true

require_relative '../../../lib/task_cli/control'
require_relative '../../../lib/task'

RSpec.describe TaskMaster::TaskCLI::Control do
  context '.initialize' do
    it 'initialize a taskmaster cli control with given command and arguments' do
      control = described_class.new(:list, 'my arg1', 'my arg 2')

      expect(control.instance_variable_get(:@command)).to eq(:list)
      expect(control.instance_variable_get(:@args)).to eq(['my arg1', 'my arg 2'])
    end
  end

  context '#list' do
    it 'should render ascii table of tasks' do
      allow(TaskMaster::Task).to receive(:list).and_return([])
      expect(TaskMaster::Task).to receive(:list)

      control = described_class.new(:list)
      expect(control).to receive(:render_table)

      control.run
    end
  end

  context '#create' do
    it 'should create a task' do
      task_desc = 'New task'
      task_stub = instance_double(TaskMaster::Task, save: nil)

      allow(TaskMaster::Task).to receive(:new) { task_stub }

      control = described_class.new(:create, [task_desc])

      expect(TaskMaster::Task).to receive(:new).with({ desc: task_desc })
      expect(task_stub).to receive(:save)
      expect(control).to receive(:render_table)

      control.run
    end
  end

  context '#delete' do
    it 'should delete task by id' do
      task = {
        id: 1,
        description: 'my task',
        status: :todo
      }

      allow(TaskMaster::Task).to receive(:find).with(task[:id]).and_return(task)

      control = described_class.new(:delete, task[:id])
      expect(control).to receive(:render_table).with([task])
      expect(TaskMaster::Task).to receive(:delete).with(task[:id])

      control.run
    end

    it 'should not attempt to delete task if it does not exist' do
      task_id = 1

      allow(TaskMaster::Task).to receive(:find).with(task_id).and_return(nil)

      control = described_class.new(:delete, task_id)
      expect(control).not_to receive(:render_table)
      expect(TaskMaster::Task).not_to receive(:delete)

      control.run
    end
  end

  context '#edit' do
    it 'should edit a task' do
      task = {
        id: 1,
        description: 'not edited yet',
        status: :todo
      }

      edited_description = 'edited now'

      edited_task = task.merge({ description: edited_description })

      allow(TaskMaster::Task).to receive(:find).twice.and_return(task, edited_task)
      allow(TaskMaster::Task).to receive(:edit).with(task[:id], { desc: edited_description }).and_return(edited_task)

      control = described_class.new(:edit, task[:id], edited_description)
      expect(control).to receive(:render_table).with([edited_task])

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
