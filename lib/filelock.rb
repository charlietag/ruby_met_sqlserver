class Filelock
  attr_accessor :file
  def initialize(f=__FILE__)
    @file = f
  end

  def lock
    f = File.open(@file, 'r')
    if ! f.flock(File::LOCK_EX | File::LOCK_NB)
      puts "Another instance is already running"
      exit
    end
  end
end
