# frozen_string_literal: true

require_relative '../../lib/json_store'
require_relative '../../lib/task'

RSpec.describe TaskMaster::Task do
  let(:tasks) {
    [
      {
        id: 1,
        description: 'task 1',
        status: :in_progress
      },
      {
        id: 2,
        description: 'task 2',
        status: :in_progress
      }
    ]
  }

  let(:json_store_double) { class_double(TaskMaster::JSONStore) }

  context '.delete' do
    it 'should delete task if exists' do
      allow(described_class).to receive(:list).and_return(tasks)
      allow(described_class).to receive(:store).and_return(json_store_double)
      allow(json_store_double).to receive(:save!)

      expect(json_store_double).to receive(:set).with(:tasks, [tasks[1]])

      described_class.delete(tasks[0][:id])
    end

    it 'should not attempt to delete from store if task does not exist' do
      allow(described_class).to receive(:list).and_return([])

      expect(described_class).not_to receive(:store)

      described_class.delete(1)
    end
  end

  context '.done' do
    it 'should mark task as done' do
      allow(described_class).to receive(:done).and_call_original
      allow(described_class).to receive(:edit)

      expect(described_class).to receive(:edit).with(1, status: :done)

      described_class.done(1)
    end
  end

  context '.edit' do
    it 'should edit task by id' do
      allow(described_class).to receive(:list).and_return(tasks)
      allow(described_class).to receive(:store).and_return(json_store_double)

      expect(json_store_double).to receive(:set).with(:tasks, [
        {
          id: 1,
          description: 'edited',
          status: :done
        },
        tasks[1]
      ])
      expect(json_store_double).to receive(:save!)

      described_class.edit(1, { desc: 'edited', status: :done })
    end

    it 'should not attempt to edit if task does not exist' do
      allow(described_class).to receive(:list).and_return([])

      expect(described_class).not_to receive(:store)

      described_class.edit(1, { desc: 'edited', status: :done })
    end
  end

  context '.find' do
    it 'should find a task by id' do
      allow(described_class).to receive(:list).and_return(tasks)

      task = described_class.find(1)

      expect(task).to be(tasks[0])
    end

    it 'should return nil if task not found' do
      allow(described_class).to receive(:list).and_return([])

      task = described_class.find(1)

      expect(task).to be(nil)
    end
  end

  context '.list' do
    it 'should list tasks' do
      allow(described_class).to receive(:store).and_return(json_store_double)

      expect(json_store_double).to receive(:get).and_return(tasks)
      expect(described_class.list).to eq(tasks)
    end
  end

  context '.store' do
    it 'should return a JSON store class' do
      expect(described_class.store).to be(TaskMaster::JSONStore)
    end
  end

  context '#initialize' do
    it 'should create a @task' do
      allow(described_class).to receive(:list).and_return([])

      task = described_class.new({ desc: 'my new task' })

      expect(task.instance_variable_get(:@task)).to eq({
        id: 1,
        description: 'my new task',
        status: :todo
      })
    end
  end

  context '#get' do
    it 'should return a task hash' do
      task = described_class.new({ desc: 'my new task' })

      expect(task.get).to eq({
        id: described_class.list.length + 1,
        description: 'my new task',
        status: :todo
      })
    end
  end

  context '#save' do
    it 'should save a task to json store' do
      allow(described_class).to receive(:list).and_return([])

      task = described_class.new({
        desc: 'my new task'
      })

      expect(described_class).to receive(:store).twice.and_return(json_store_double)
      expect(json_store_double).to receive(:set).with(:tasks, [task.get])
      expect(json_store_double).to receive(:save!)

      task.save
    end
  end

  context '#set' do
    it 'should set task data' do
      task = described_class.new({ desc: 'my new task' })
      task.set({ desc: 'my updated task' })

      expect(task.get[:description]).to eq('my updated task')
    end

    it 'should not set invalid task property' do
      task = described_class.new({ desc: 'my new task' })
      task.set({ new_property: 'new' })

      expect(task.get[:new_property]).to be(nil)
    end
  end
end
