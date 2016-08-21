class Filelock
  def initialize(f=__FILE__)
    @file = f
    @fopen = ""
  end

  def lock
    @fopen = File.open(@file, 'r')
    if ! @fopen.flock(File::LOCK_EX | File::LOCK_NB)
      puts "Another instance is already running"
      exit
    end
  end

  def close
    @fopen.close
  end
end
