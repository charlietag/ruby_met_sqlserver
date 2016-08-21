class Fileopen
  attr_accessor :content
  def initialize(f="/tmp/erp.html")
    @html_file = f
    @content = ""
  end

  def write
    File.open(@html_file, 'w') do |f|
      f.puts @content
    end
  end
end
