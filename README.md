* Purpose
  * Connect to sqlserver, and fetch data from sql server with ruby
* Environment
  * CentOS 7
* Database
  * SqlServer 2008 R2
* Prerequisite
  <pre>yum install freetds freetds-devel openssl openssl-libs openssl-devel libticonv-devel -y</pre>
  <pre>bundle install</pre>
* Ruby Gem
  <pre>tiny_tds</pre>
* Usage
  * Config file
  <pre>config/database.yml</pre>
  * Generated HTML
  <pre>output/erp_user_priv.html</pre>
  * Execute script
  <pre>chmod 777 erp_user_priv.rb</pre>
  <pre>&lt;PATH&gt;/erp_user_priv.rb</pre>
