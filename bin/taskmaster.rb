#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/task_cli/control'

command = ARGV[0]
args = ARGV[1..ARGV.length]

control = TaskMaster::TaskCLI::Control.new(command, args)
control.run
