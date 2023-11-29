# frozen_string_literal: true

require 'uri'
require 'json'
require 'net/http'
require 'rest-client'

module TestOpenai
  # The file object used by OpenAI API
  class File
    # @return [String] Type of the data. Always: 'file'.
    attr_accessor :object
    # @return [String] The id of the data.
    attr_accessor :id
    # @return [String] The purpose of the data.
    attr_accessor :purpose
    # @return [String] Original filename.
    attr_accessor :filename
    # @return [Integer] Size of the file in bytes.
    attr_accessor :bytes
    # @return [Integer] Timestamp in seconds of creation time of the file.
    attr_accessor :created_at

    def initialize(**args)
      @object = args[:object]
      @id = args[:id]
      @purpose = args[:purpose]
      @filename = args[:filename]
      @bytes = args[:bytes]
      @created_at = args[:created_at]
    end
  end

  class ListFilesResp
    # @return [String] Type of the data. Ex: 'list'.
    attr_accessor :object
    # @return [Boolean] Whether there are more data to load.
    attr_accessor :has_more
    # @return [Array<TestOpenai::File>] The list of files.
    attr_accessor :data

    def initialize(**args)
      @object = args.fetch(:object, 'list')
      @has_more = args.fetch(:has_more, false)
      @data = args.fetch(:data, [])
    end
  end

  class DeleteFileResp
    # @return [String] Type of the data. Ex: 'file'.
    attr_accessor :object
    # @return [String] The id of the data.
    attr_accessor :id
    # @return [true, false] Whether the data was deleted.
    attr_accessor :deleted

    def initialize(**args)
      @object = args.fetch(:object, 'file')
      @id = args.fetch(:id, '')
      @deleted = args.fetch(:deleted, false)
    end
  end
end
