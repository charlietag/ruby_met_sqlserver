#!/usr/local/bin/ruby
require_relative 'lib/app'

#---------Define Filename----------
# f.realpath
# f.html_name
# f.yml_name
f = Filepath.new __FILE__
#---------Define Filename----------

#---------Script Lock----------
script = Filelock.new f.realpath
script.lock
#---------Script Lock----------

#---------local variable----------
user_exclude = ["admin", "DS"]
html_text = ""

time = Time.new
html_text << "refresh at: " + time.strftime("%Y-%m-%d %H:%M:%S")
html_text << "\n"
html_text << "---------------------------------------------------------"
html_text << "\n"

#==================================================Main Usage===================================================
#--------------------------------Object--------------------------------
users = Sqlserver.new f.yml_name
schools = Sqlserver.new f.yml_name
privs = Sqlserver.new f.yml_name
ifpowers = Sqlserver.new f.yml_name

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
  next if user_exclude.include? user['userid'] # exclude array
  html_text << "==============#{user['userid']}================"
  html_text << "\n"
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
        html_text << "#{school['schoolname']}:超級使用者"
        html_text << "\n"
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
          #html_text << "#{school['schoolname']}:#{priv['prog']}"
          all_privs << "#{priv['prog']}"
        end
        if !all_privs.empty?
          html_text << "#{school['schoolname']}:"
          html_text << "\n"
          html_text << all_privs.join(", ")
          html_text << "\n"
        end
      end
    end
  end
  html_text << "=================================="
  html_text << "\n"
end
#==================================================Main Usage===================================================

#------------Write to html file-------------
fhtml = Fileopen.new f.html_name
fhtml.content = html_text
fhtml.write
#------------Write to html file-------------

#---------Script Lock----------
script.close
#---------Script Lock----------
