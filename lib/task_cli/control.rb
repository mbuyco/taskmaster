# frozen_string_literal: true

require 'terminal-table'

require_relative '../task'
require_relative './commands'

module TaskMaster
  module TaskCLI
    class Control
      def initialize(command, args)
        if command.nil?
          handle_command(:list)
          exit
        end

        unless valid_command?(command)
          puts "ERROR: Invalid command\n\n"
          puts 'List of commands:'
          puts TaskCLI::Commands.list.join("\n")
          exit(1)
        end

        Task.initialize_store

        handle_command(command, args)
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

        Terminal::Table.new({
          rows: table,
          style: { width: 60 }
        })
      end

      private

      def valid_command?(command)
        TaskCLI::Commands.list.include?(command.to_sym)
      end

      def handle_command(command, args = [])
        puts

        case command.to_sym
        when :create
          Task.new({ desc: args[0..args.length].join(' ') }).save
          puts render_table(Task.list)
        when :list
          puts render_table(Task.list)
        when :delete
          id = args[0].to_i
          task = Task.find(id)

          return if task.nil?

          puts 'Deleted task:'
          puts render_table([Task.find(id)])
          
          Task.delete(args[0].to_i)
        when :edit
          id = args[0].to_i
          task = Task.find(id)

          return if task.nil?

          Task.edit(id, args[1])

          puts 'Edited task:'
          puts render_table([task])
        end

        puts
      end
    end
  end
end
