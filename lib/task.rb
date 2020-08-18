# frozen_string_literal: true

require_relative 'constants'
require_relative 'json_store'

module TaskMaster
  class Task
    extend Status

    @file_path = File.expand_path('../store/tasks.json', __dir__)
    @store = JSONStore.read(@file_path)

    def self.list
      @store.get(:tasks)
    end

    def self.store
      @store
    end

    def self.find(id)
      Task.list.find { |row| row[:id] == id }
    end

    def self.delete(id)
      Task.list.delete_if { |row| row[:id] == id }
      Task.store.set(:tasks, Task.list)
      Task.store.save!
    end

    def self.edit(id, description)
      row_index = Task.list.find_index { |row| row[:id] == id }
      Task.list[row_index][:description] = description

      Task.store.set(:tasks, Task.list)
      Task.store.save!
    end

    def self.initialize_store
      @store.create(@file_path, { tasks: [] })
    end

    def initialize(options)
      @task = {
        id: Task.list.length + 1,
        description: options[:desc],
        status: options[:status] || Status::TODO
      }
    end

    def save
      return if @task.nil?

      Task.store.set(:tasks, [*Task.list, @task])
      Task.store.save!
      @task = nil
    end
  end
end
