# frozen_string_literal: true

require 'spec_helper'
require 'test_openai'
require 'net/http'

describe TestOpenai::Client do
  describe 'default behaviour' do
    openai_client = TestOpenai::Client.new

    it 'should return the default host' do
      expect(openai_client.openai_host).to eq('https://api.openai.com')
    end

    it 'should return the default key' do
      expect(openai_client.openai_key).to eq('')
    end
  end

  describe '#initialize' do
    openai_client = TestOpenai::Client.new('https://api.openai.com/v1', 'test_key')

    it 'should set the host' do
      expect(openai_client.openai_host).to eq('https://api.openai.com/v1')
    end

    it 'should set the key' do
      expect(openai_client.openai_key).to eq('test_key')
    end
  end

  describe 'able to set parameters' do
    openai_client = TestOpenai::Client.new

    it 'should set the host' do
      openai_client.openai_host = 'https://api.openai.com/v1'
      expect(openai_client.openai_host).to eq('https://api.openai.com/v1')
    end

    it 'should set the key' do
      openai_client.openai_key = 'test_key'
      expect(openai_client.openai_key).to eq('test_key')
    end
  end

  describe 'error' do
    it 'on null host' do
      openai_client = TestOpenai::Client.new('', 'test_key')
      expect { openai_client.list_files }.to raise_error(StandardError)
    end

    it 'on wrong api key' do
      openai_client = TestOpenai::Client.new('https://api.openai.com/v1', 'test_key')
      expect { openai_client.list_files }.to raise_error(StandardError)
    end
  end

  describe 'call real api' do
    openai_client = TestOpenai::Client.new(
      ENV['OPENAI_API_HOST'],
      ENV['OPENAI_API_KEY']
    )
    uploaded_file_id = nil

    it 'should list files' do
      list_files = TestOpenai::ListFilesResp.new
      expect {
        list_files = openai_client.list_files
      }.not_to raise_error
      expect(list_files.object).to eq('list')
      expect(list_files.has_more).to eq(false)
      expect(list_files.data).to be_a(Array)
      list_files.data.each do |file|
        expect_file(file)
      end
    end

    it 'should upload file' do
      uploaded_file = TestOpenai::File.new
      expect {
        uploaded_file = openai_client.upload_file('./spec/sample.pdf')
      }.not_to raise_error
      expect_file(uploaded_file)
      uploaded_file_id = uploaded_file.id
    end

    it 'should get file' do
      expect_string(uploaded_file_id)
      gotten_file = TestOpenai::File.new
      expect {
        gotten_file = openai_client.get_file(uploaded_file_id || '')
      }.not_to raise_error
      expect_file(gotten_file)
    end

    it 'should get file content' do
      expect_string(uploaded_file_id)
      file_content = TestOpenai::File.new
      expect {
        file_content = openai_client.get_file_content(uploaded_file_id)
      }.to raise_error(StandardError)
    end

    it 'should delete file' do
      expect_string(uploaded_file_id)
      deleted_file = TestOpenai::DeleteFileResp.new
      expect {
        deleted_file = openai_client.delete_file(uploaded_file_id || '')
      }.not_to raise_error
      expect(deleted_file).not_to be_nil
      expect_string(deleted_file.object)
      expect_string(deleted_file.id)
      expect_bool(deleted_file.deleted)
    end
  end
end

def expect_file(file)
  expect(file).not_to be_nil
  expect_string(file.object)
  expect_string(file.id)
  expect_string(file.purpose)
  expect_string(file.filename)
  expect_integer(file.bytes)
  expect_integer(file.created_at)
end

def expect_string(data)
  expect(data).not_to be_nil
  expect(data).to be_a(String)
end

def expect_integer(data)
  expect(data).not_to be_nil
  expect(data).to be_a(Integer)
end

def expect_bool(data)
  expect(data).not_to be_nil
  expect(data).to be_a(TrueClass).or be_a(FalseClass)
end
