require 'tiny_tds'
require 'yaml'

class Sqlserver
  #.........initialize.........
  attr_accessor :sql
  def initialize(filename)
    @dbcon ||= YAML.load_file(filename)
  end

  #........Database Connection........
  def connect
    @client = TinyTds::Client.new username: @dbcon['username'], password: @dbcon['password'], host: @dbcon['host']
    exit if @client.active? == false
  end

  #...........Start Query..........
  def getdata
    results = @client.execute(@sql)
  end

end # end of class
