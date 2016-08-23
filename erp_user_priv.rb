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
time = Time.new
html_content = ""
#---------local variable----------


#==================================================Main Usage===================================================
#--------------------------------Database Object--------------------------------
users = Sqlserver.new f.yml_name
schools = Sqlserver.new f.yml_name
privs = Sqlserver.new f.yml_name
system_type = Sqlserver.new f.yml_name
ifpowers = Sqlserver.new f.yml_name

users.connect
schools.connect
privs.connect
system_type.connect
ifpowers.connect
#--------------------------------Database Object--------------------------------

#--------------------------------HTML Content--------------------------------
html_content << "Refresh at: " + time.strftime("%Y-%m-%d %H:%M:%S")
html_content << "<hr>"

html_content << %{
  <table class="ui selectable celled table" id="demo">
    <thead>
      <tr>
        <th>User</th>
        <th>School</th>
        <th>Privilege</th>
      </tr>
    </thead>
    <tbody>
}
#--------------------------------HTML Content--------------------------------

users.sql = %{SELECT LTRIM(RTRIM(MA001)) userid
FROM [SMARTDSCSYS].[dbo].[DSCMA]
WHERE MA005 = ''
ORDER BY MA001
}
schools.sql = %{SELECT LTRIM(RTRIM(MB003)) schoolid,LTRIM(RTRIM(MB002)) schoolname
FROM [SMARTDSCSYS].[dbo].[DSCMB]}

system_type.sql = %{
  SELECT LTRIM(RTRIM(MA001)) systemid, LTRIM(RTRIM(MA002)) systemname
  FROM [SMARTDSCSYS].[dbo].[ADMMA]
}
system_type_data = system_type.fetch

all_privs = Array.new
all_privs_system = Array.new
#.....user loop....
users.fetch.each do |user|
  next if user_exclude.include? user['userid'] # exclude array
  #html_content << %{#{user['userid']}}
  #.....school loop.....
  schools.fetch.each do |school|
    user_exists = false
    #....if power loop.....
    ifpowers.sql = %{
      SELECT LTRIM(RTRIM(MF005)) ifpower
      FROM [#{school['schoolid']}].[dbo].[ADMMF]
      WHERE MF001 = '#{user['userid']}'
    }
    ifpowers.fetch.each do |ifpower|
      user_exists = true
      if ifpower['ifpower'] == 'Y'
        html_content << %{
          <tr class="warning">
            <td>#{user['userid']}</td>
            <td>#{school['schoolname']}</td>
            <td>超級使用者</td>
          </tr>
        }
      else
        #.......privs.......
        all_privs.clear
        all_privs_system.clear
        privs.sql = %{
        SELECT distinct LTRIM(RTRIM(SUBSTRING(MG002,1,3))) prog
        FROM [#{school['schoolid']}].[dbo].[ADMMG]
        WHERE MG001 = '#{user['userid']}'
        ORDER BY prog
        }
        privs.fetch.each do |priv|
          all_privs << "#{priv['prog']}"
        end
        #if !all_privs.empty? #uncomment this to fethc data only data exists
          all_privs_flag = true
          all_privs.each do |all_priv|
            system_type_data.each do |data|
              if data['systemid'] == all_priv
                all_privs_system << %{<span class="ui green label">#{data['systemid']}</span>(#{data['systemname']})}
                all_privs_flag = false
              end
            end
            all_privs_system << %{<span class="ui green label">#{all_priv}</span>} if all_privs_flag == true
          end
          html_content << %{
            <tr>
              <td>#{user['userid']}</td>
              <td>#{school['schoolname']}</td>
              <td>#{all_privs_system.join(", &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")}</td>
            </td>
          }
        #end #uncomment this to fethc data only data exists
      end
    end #ifpower
        #-------comment this to fethc data only data exists-------
        if user_exists == false
          html_content << %{
            <tr>
              <td>#{user['userid']}</td>
              <td>#{school['schoolname']}</td>
              <td></td>
            </td>
          }
        end
        #-------comment this to fethc data only data exists-------
  end #school
end #user
#--------------------------------HTML Content--------------------------------
  html_content << %{
      </tbody>
    </table>
  }
#--------------------------------HTML Content--------------------------------
#==================================================Main Usage===================================================

#------------Write to html file-------------
fhtml = Fileopen.new f.html_name
fhtml.content = html_content
fhtml.write
#------------Write to html file-------------

#---------Script Unlock----------
script.unlock
#---------Script Lock----------
