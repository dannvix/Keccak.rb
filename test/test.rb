require "../Keccak"

VECTORS = [[  "0", 1024,  576,   0],
           ["224", 1152,  448, 224],
           ["256", 1088,  512, 256],
           ["384",  832,  768, 384],
           ["512",  576, 1024, 512]]
FILE_TYPES = ["Short", "Long"]

keccak = Keccak.new
VECTORS.each do |vector|
  suffix, r, c, n = vector

  FILE_TYPES.each do |file_type|
    pathname = "vectors/#{file_type}MsgKAT_#{suffix}.txt"
    test_cases = File.read pathname
    
    len, msg, md = nil, nil, nil
    counter = 0
    test_cases.split("\n").each do |line|
      len = line.split(" = ").last.chomp.to_i if line.start_with? "Len"
      msg = line.split(" = ").last.chomp if line.start_with? "Msg"

      if line.start_with? "MD" or line.start_with? "Squeezed"
        md = line.split(" = ").last.chomp.downcase
        n = (md.length / 2) * 8 if n == 0

        bytes = msg.chars.each_slice(2).to_a.map{|b| b.join.to_i(16).chr }.join
        my_md = keccak.hexdigest(bytes, r, c, n, len)

        counter += 1
        if not md == my_md
          puts "#{pathname.ljust(32)}: Failed :("
          exit(1)
        end
      end
    end

    puts "#{pathname.ljust(32)}: Passed (#{counter} hashes)"
  end
end
