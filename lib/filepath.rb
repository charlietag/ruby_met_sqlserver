class Filepath
  def initialize(f=__FILE__)
    this_script = File.realpath f # /home/ruby_met_sqlserver/erp_user_priv.rb
    this_script_dir = File.dirname this_script # /home/ruby_met_sqlserver
    this_script_ext = File.extname this_script # .rb
    this_script_basename = File.basename this_script,this_script_ext # erp_user_priv
    
    @to_html_name = this_script_dir + %{/} + this_script_basename + %[.html] # erp_user_priv.html
    @to_yml_name = this_script_dir + %{/} + this_script_basename + %[.yml] # erp_user_priv.yml
  end

  def to_html_name
    @to_html_name
  end

  def to_yml_name
    @to_yml_name
  end
end
