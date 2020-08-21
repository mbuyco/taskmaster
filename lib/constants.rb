# frozen_string_literal: true

module TaskMaster
  module Constants
    module Status
      DONE = :done
      IN_PROGRESS = :in_progress
      TODO = :todo
    end

    module Commands
      CREATE = :create
      DELETE = :delete
      DONE = :done
      EDIT = :edit
      LIST = :list
      START = :start

      def self.all
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
