class Fileopen
  attr_accessor :content
  def initialize(f="/tmp/erp.html")
    @output_html = f
    @content = ""
  end

  def write
    File.open(@output_html, 'w') do |f|
      f.puts @content
    end
  end
end
