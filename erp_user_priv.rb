#!/usr/local/bin/ruby
require_relative 'lib/app'

#---------Define Filename----------
# f.realpatha # /<PATH>/<SCRIPT>.rb
# f.html_name # /<PATH>/output/<SCRIPT>.html
# f.yml_name  # /<PATH>/config/database.yml
f = Filepath.new __FILE__
#---------Define Filename----------

#---------Script Lock----------
script = Filelock.new f.realpath
script.lock
#---------Script Lock----------

#---------local variable----------
user_exclude = ["admin", "DS"]
html_content = ""

time = Time.new
html_content << "refresh at: " + time.strftime("%Y-%m-%d %H:%M:%S")
html_content << "<hr>"

#==================================================Main Usage===================================================
#--------------------------------Database Object--------------------------------
users = Sqlserver.new f.yml_name
schools = Sqlserver.new f.yml_name
privs = Sqlserver.new f.yml_name
ifpowers = Sqlserver.new f.yml_name

users.connect
schools.connect
privs.connect
ifpowers.connect
#--------------------------------Database Object--------------------------------

users.sql = %{SELECT LTRIM(RTRIM(MA001)) userid
FROM [SMARTDSCSYS].[dbo].[DSCMA]
WHERE MA005 = ''
}
schools.sql = %{SELECT LTRIM(RTRIM(MB003)) schoolid,LTRIM(RTRIM(MB002)) schoolname
FROM [SMARTDSCSYS].[dbo].[DSCMB]}

all_privs = Array.new
#.....user loop....
users.fetch.each do |user|
  next if user_exclude.include? user['userid'] # exclude array
  html_content << %{
    <div class="ui massive label">
      #{user['userid']}
    </div>
    <table class="ui selectable celled table">
      <thead>
        <tr>
          <th>School</th>
          <th>Privilege</th>
        </tr>
      </thead>
      <tbody>
  }
  #.....school loop.....
  schools.fetch.each do |school|
    #....if power loop.....
    ifpowers.sql = %{
      SELECT LTRIM(RTRIM(MF005)) ifpower
      FROM [#{school['schoolid']}].[dbo].[ADMMF]
      WHERE MF001 = '#{user['userid']}'
    }
    ifpowers.fetch.each do |ifpower|
      if ifpower['ifpower'] == 'Y'
        html_content << %{
          <tr>
            <td>#{school['schoolname']}</td>
            <td>超級使用者</td>
          </tr>
        }
      else
        #.......privs.......
        all_privs.clear
        privs.sql = %{
        SELECT distinct LTRIM(RTRIM(SUBSTRING(MG002,1,3))) prog
        FROM [#{school['schoolid']}].[dbo].[ADMMG]
        WHERE MG001 = '#{user['userid']}'
        ORDER BY prog
        }
        privs.fetch.each do |priv|
          all_privs << "#{priv['prog']}"
        end
        if !all_privs.empty?
          html_content << %{
            <tr>
              <td>#{school['schoolname']}</td>
              <td>#{all_privs.join(", ")}</td>
            </td>
          }
        end
      end
    end
  end
  html_content << %{
      </tbody>
    </table>
  }
end
#==================================================Main Usage===================================================

#------------Write to html file-------------
fhtml = Fileopen.new f.html_name
fhtml.content = html_content
fhtml.write
#------------Write to html file-------------

#---------Script Unlock----------
script.unlock
#---------Script Lock----------
