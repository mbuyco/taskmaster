# frozen_string_literal: true

require_relative '../../lib/json_store'

RSpec.describe TaskMaster::JSONStore do
  let(:file_path) { './store/tasks.json' }

  before(:each) do
    @file = described_class.read(file_path)
  end

  context '.read' do
    it 'should read json file' do
      expect(@file.instance_variable_defined?(:@file_path)).to eq(true)
      expect(@file.instance_variable_defined?(:@store)).to eq(true)
      expect(@file).to be(described_class)
    end

    it 'should return nil if file not found' do
      file_path = './non_existent.json'

      @file = described_class.read(file_path)

      expect(@file).to eq(nil)
    end
  end

  context '.get' do
    it 'should get store property by property name' do
      @file.instance_variable_set(:@store, { tasks: [] })

      prop = @file.get(:tasks)

      expect(prop).to eq([])
    end
  end

  context '.set' do
    it 'should allow to set property' do
      @file.instance_variable_set(:@store, { tasks: [] })

      tasks = [{ id: 1, description: 'my new task' }]

      @file.set(:tasks, tasks)

      expect(@file.instance_variable_get(:@store)[:tasks]).to eq(tasks)
    end
  end

  context '.save!' do
    it 'should save task to file' do
      allow(File).to receive(:write)

      store = {
        tasks: [
          {
            id: 1,
            description: 'my new task',
            status: :done
          }
        ]
      }

      expect(File).to receive(:write).with(file_path, JSON.generate(store))

      @file.set(:tasks, store[:tasks])
      @file.save!
    end
  end
end
