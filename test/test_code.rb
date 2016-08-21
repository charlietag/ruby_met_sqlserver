#!/usr/local/bin/ruby
class Haha
  def haha mytext
    @haha = mytext
  end
  def sayhello
    @haha
  end
end

f = Haha.new
f.haha "Man"
puts f.sayhello

#all_arr = Array.new
#str = "haha"
#str1 = "bb"
#all_arr << str
#all_arr << str1
#
#def print_help(all_arr)
#  puts all_arr
#end
#
#print_help(all_arr)
#all_arr.each do |x|
#  puts x
#end
