require 'tiny_tds'
require 'yaml'

#dbcon ||= YAML.load_file(filename)
#puts dbcon['username']
#
#class Sqlserver
#  #........db info........
#  @@username = ''
#  @@password = ''
#  @@host = ''
#
#  #.........initialize.........
#  attr_accessor :sql
#  def initialize(sql="")
#    @sql = sql
#  end
#
#  #........Database Connection........
#  def connect
#    @client = TinyTds::Client.new username: @@username, password: @@password, host: @@host
#    exit if @client.active? == false
#  end
#
#  #...........Start Query..........
#  def getdata
#    results = @client.execute(@sql)
#  end
#
#end # end of class
