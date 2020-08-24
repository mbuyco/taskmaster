# frozen_string_literal: true

require 'terminal-table'

require_relative '../task'
require_relative '../constants'

module TaskMaster
  module TaskCLI
    class Control
      def initialize(command, *args)
        @command = command.nil? ? :list : command.to_sym
        @args = args.flatten || []
      end

      def render_table(rows)
        if rows.empty?
          table = [[{ alignment: :center, value: 'No tasks found' }]]
        else
          table = []

          table << rows[0].keys.map(&:to_s)
          table << :separator

          rows.each { |row| table << row.values.map(&:to_s) }
        end

        Terminal::Table.new({ rows: table })
      end

      def run
        return unless valid_command?(@command)

        puts
        send(@command)
        puts
      end

      private

      def create
        Task.new({ desc: @args.join('') }).save
        puts render_table(Task.list)
      end

      def delete
        id = @args[0].to_i
        task = Task.find(id)

        return if task.nil?

        puts 'Deleted task:'
        puts render_table([task])

        Task.delete(id)
      end

      def edit
        task = Task.find(@args[0].to_i)

        return if task.nil?

        Task.edit(task[:id], { desc: @args[1..@args.length].join('') })

        puts 'Edited task:'
        puts render_table([Task.find(task[:id])])
      end

      def list
        puts render_table(Task.list)
      end

      def valid_command?(command)
        Constants::Commands.all.include?(command.to_sym)
      end
    end
  end
end
