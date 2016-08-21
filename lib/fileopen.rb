class Fileopen
  def initialize(f=__FILE__)
  end

  def iflock(lockfile="")
    exit if lockfile == ""
    f = File.open(lockfile, 'r')
    if ! f.flock(File::LOCK_EX | File::LOCK_NB)
      puts "Another instance is already running"
      exit
    end
    sleep 10
    exit
  end

end
