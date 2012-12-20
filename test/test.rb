require "../Keccak"

# hash types: [r, c, n]
TYPES = [[1024, 576, 0], [1152, 448, 224], [1088, 512, 256], [832, 768, 384], [576, 1024, 512]]

keccak = Keccak.new
TYPES.each do |r, c, n|
  ["short", "long"].each do |case_t|
    pathname = "vectors/#{case_t}_#{n}.csv"

    counter = 0
    test_cases = File.open(pathname).each do |line|
      len, msg, md = line.split(",")
      bytes = msg.chars.each_slice(2).to_a.map{|b| b.join.to_i(16).chr }.join
      _n = (n == 0) ? (md.length / 2 * 8) :  n
      my_md = keccak.hexdigest(bytes, r, c, _n, len.to_i)
   
      counter += 1
      if not md.chomp == my_md
        puts "#{pathname}: failed :("
        exit(1)
      end
    end

    puts "#{pathname}: passed (#{counter} hashes)"
  end
end
