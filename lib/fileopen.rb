class Fileopen
  attr_accessor :html_text
  def initialize(f="/tmp/erp.html")
    @output_html = f
    @html_text = ""
  end

  def writefile
    File.open(@output_html, 'w') do |f|
      if ! f.flock(File::LOCK_EX | File::LOCK_NB)
        puts "Another instance is already running"
        exit
      end
      f.puts @html_text
    end
  end
  #def iflock(lockfile="")
  #  exit if lockfile == ""
  #  f = File.open(lockfile, 'r')
  #  if ! f.flock(File::LOCK_EX | File::LOCK_NB)
  #    puts "Another instance is already running"
  #    exit
  #  end
  #  sleep 10
  #  exit
  #end

end
