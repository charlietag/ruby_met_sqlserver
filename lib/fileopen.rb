class Fileopen
  attr_accessor :content
  def initialize(f="/tmp/erp.html")
    @output_html = f
    @content = ""
  end

  def write
    File.open(@output_html, 'w') do |f|
      if ! f.flock(File::LOCK_EX | File::LOCK_NB)
        puts "Another instance is already running"
        exit
      end
      f.puts @content
      puts "haha"
      sleep 10
    end
  end
end
