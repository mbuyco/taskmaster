# frozen_string_literal: true

require 'json'

module TaskMaster
  class JSONStore
    def self.create(file_path, data = {})
      return if File.exist?(file_path)

      @file_path = file_path
      File.write(@file_path, data)
    end

    def self.read(file_path)
      @file_path = file_path

      if File.exist?(@file_path)
        file = File.read(@file_path)
      else 
        file = File.write(@file_path)
      end

      @store = JSON.parse(file, { symbolize_names: true })
      self
    end

    def self.get(property_name)
      return nil if @store.nil?

      @store[property_name.to_sym]
    end

    def self.set(property_name, value)
      return nil if @store.nil?

      @store[property_name.to_sym] = value
    end

    def self.save!
      File.write(@file_path, JSON.generate(@store))
    end
  end
end
