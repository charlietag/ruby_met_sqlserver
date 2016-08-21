#!/usr/local/bin/ruby
require_relative 'lib/app'

#---------Define Filename----------
this_file = Filepath.new __FILE__
# this_file.to_html_name
# this_file.to_yml_name
#---------Define Filename----------

time = Time.new
puts "refresh at: " + time.strftime("%Y-%m-%d %H:%M:%S")
puts "---------------------------------------------------------"

#==================================================Main Usage===================================================
#--------------------------------Object--------------------------------
users = Sqlserver.new
schools = Sqlserver.new
privs = Sqlserver.new
ifpowers = Sqlserver.new

users.connect
schools.connect
privs.connect
ifpowers.connect

#--------------------------------Object--------------------------------

users.sql = %{SELECT LTRIM(RTRIM(MA001)) userid
FROM [SMARTDSCSYS].[dbo].[DSCMA]
WHERE MA005 = ''
}
schools.sql = %{SELECT LTRIM(RTRIM(MB003)) schoolid,LTRIM(RTRIM(MB002)) schoolname
FROM [SMARTDSCSYS].[dbo].[DSCMB]}

all_privs = Array.new
#.....user loop....
users.getdata.each do |user|
  puts "==============#{user['userid']}================"
  #.....school loop.....
  schools.getdata.each do |school|
    #....if power loop.....
    ifpowers.sql = %{
      SELECT LTRIM(RTRIM(MF005)) ifpower
      FROM [#{school['schoolid']}].[dbo].[ADMMF]
      WHERE MF001 = '#{user['userid']}'
    }
    ifpowers.getdata.each do |ifpower|
      if ifpower['ifpower'] == 'Y'
        puts "#{school['schoolname']}:超級使用者"
      else
        #.......privs.......
        all_privs.clear
        privs.sql = %{
        SELECT distinct LTRIM(RTRIM(SUBSTRING(MG002,1,3))) prog
        FROM [#{school['schoolid']}].[dbo].[ADMMG]
        WHERE MG001 = '#{user['userid']}'
        ORDER BY prog
        }
        privs.getdata.each do |priv|
          #puts "#{school['schoolname']}:#{priv['prog']}"
          all_privs << "#{priv['prog']}"
        end
        if !all_privs.empty?
          puts "#{school['schoolname']}:"
          puts all_privs.join(", ")
          puts
        end
      end
    end
  end
  puts "=================================="
  puts
end
#==================================================Main Usage===================================================
