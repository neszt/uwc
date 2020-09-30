#!/usr/bin/ruby -w

hash = Hash.new(0)

re = /([a-z']+)/i

$stdin.each do |line|
	line.scan(re).each do |w|
		w = w[0]
		hash[w] = hash[w] + 1
	end
end

hash.keys.sort_by! { |x| [hash[x], x] }.each do |w|
	puts "#{w} #{hash[w]}"
end
