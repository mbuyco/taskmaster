# frozen_string_literal: true

module TaskMaster
  module TaskCLI
    module Commands
      CREATE = :create
      DELETE = :delete
      DONE = :done
      EDIT = :edit
      LIST = :list
      START = :start

      def self.list
        [
          CREATE,
          DELETE,
          DONE,
          EDIT,
          LIST,
          START
        ]
      end
    end
  end
end
