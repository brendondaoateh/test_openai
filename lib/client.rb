# frozen_string_literal: true

require 'uri'
require 'json'
require 'net/http'
require 'rest-client'

module TestOpenai
  class Client
    attr_accessor :openai_host, :openai_key

    # @param openai_host [String] The host of the OpenAI API
    # @param openai_key [String] The key of the OpenAI API
    # @return [TestOpenai::Client] A new instance of TestOpenai::OpenAIClient
    def initialize(openai_host = 'https://api.openai.com', openai_key = '')
      @openai_host = openai_host
      @openai_key = openai_key
    end

    # @return [TestOpenai::ListFilesResp] The list of files
    def list_files
      url = "#{openai_host}/files"
      headers = {
        Authorization: "Bearer #{openai_key}"
      }
      res = RestClient.get(url, headers)

      response_data = JSON.parse(res.body)
      file_data = response_data['data']
      TestOpenai::ListFilesResp.new(
        object: response_data['object'],
        has_more: response_data['has_more'],
        data: file_data.map do |file|
          parse_as_file(file)
        end
      )
    end

    # @param file_path [String] The path of the file to upload
    # @return [TestOpenai::File] The file uploaded
    def upload_file(file_path)
      url = "#{openai_host}/files"
      headers = {
        Authorization: "Bearer #{openai_key}"
      }
      params = {
        purpose: 'assistants',
        file: ::File.new(file_path)
      }
      res = RestClient.post(url, params, headers)
      parse_as_file(JSON.parse(res.body))
    end

    # @param file_id [String] The id of the file to delete
    # @return [TestOpenai::DeleteFileResp] The response of the deletion
    def delete_file(file_id)
      url = "#{openai_host}/files/#{file_id}"
      headers = {
        Authorization: "Bearer #{openai_key}"
      }
      res = RestClient.delete(url, headers)
      response_data = JSON.parse(res.body)
      TestOpenai::DeleteFileResp.new(
        object: response_data['object'],
        id: response_data['id'],
        deleted: response_data['deleted']
      )
    end

    # @param file_id [String] The id of the file to get
    # @return [TestOpenai::File] The file gotten
    def get_file(file_id)
      url = "#{openai_host}/files/#{file_id}"
      headers = {
        Authorization: "Bearer #{openai_key}"
      }
      res = RestClient.get(url, headers)
      parse_as_file(JSON.parse(res.body))
    end

    def get_file_content(file_id)
      url = "#{openai_host}/files/#{file_id}/content"
      headers = {
        Authorization: "Bearer #{openai_key}"
      }
      res = RestClient.get(url, headers)
      res.body
    end

    # @private
    def parse_as_file(data)
      TestOpenai::File.new(
        object: data['object'],
        id: data['id'],
        purpose: data['purpose'],
        filename: data['filename'],
        bytes: data['bytes'],
        created_at: data['created_at']
      )
    end
  end
end
