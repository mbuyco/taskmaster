# frozen_string_literal: true

require_relative 'constants'
require_relative 'json_store'

module TaskMaster
  class Task
    include TaskMaster::Constants::Status

    @file_path = File.expand_path('../store/tasks.json', __dir__)
    @store = JSONStore.read(@file_path)

    def self.delete(id)
      task_index = list.find_index { |task| task[:id] == id }

      return if task_index.nil?

      list.delete_at(task_index)
      store.set(:tasks, list)
      store.save!
    end

    def self.done(id)
      edit(id, { status: DONE })
    end

    def self.edit(id, data = {})
      row_index = list.find_index { |row| row[:id] == id }

      return if row_index.nil?

      list[row_index][:description] = data[:desc]
      list[row_index][:status] = data[:status]

      store.set(:tasks, list)
      store.save!
    end

    def self.find(id)
      list.find { |row| row[:id] == id }
    end

    def self.list
      store.get(:tasks)
    end

    def self.store
      @store
    end

    def initialize(options)
      @task = {
        id: Task.list.length + 1,
        description: options[:desc],
        status: options[:status] || TODO
      }
    end

    def get
      @task
    end

    def save
      Task.store.set(:tasks, [*Task.list, @task])
      Task.store.save!
      self
    end

    def set(task)
      @task = @task.merge({
        id: task[:id] || @task[:id],
        description: task[:desc] || @task[:description],
        status: task[:status] || @task[:status]
      })
    end
  end
end
