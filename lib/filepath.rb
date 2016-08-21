
this_script = File.realpath __FILE__ # /home/ruby_met_sqlserver/erp_user_priv.rb
this_script_dir = File.dirname this_script # /home/ruby_met_sqlserver
this_script_ext = File.extname this_script # .rb
this_script_basename = File.basename this_script,this_script_ext # erp_user_priv

output_html = this_script_dir + %{/} + this_script_basename + %[.html] # 
dbcon_yml = this_script_dir + %{/} + this_script_basename + %[.yml]


filename = File.basename(__FILE__,'.*') + ".yml"
dbcon ||= YAML.load_file(filename)
puts dbcon['username']

exit
