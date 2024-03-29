class Keccak
  def self.hexdigest (msg, r=576, c=1024, n=512, len=nil)
    keccak = self.new
    keccak.hexdigest(msg, r, c, n, len)
  end

  def hexdigest (msg, r=576, c=1024, n=512, len=nil)
    # msg: message string, e.g. "hello world"
    # len: specified message length (in bits)
    # returns Keccak hash in string of hex
    hex = msg.each_byte.map{|b| "%02x" % b}.join
    len ||= (msg.length * 8)
    keccak([len, hex], r, c, n).downcase
  end

  private
    # round constants
    RC = [0x0000000000000001, 0x0000000000008082, 0x800000000000808A,
          0x8000000080008000, 0x000000000000808B, 0x0000000080000001,
          0x8000000080008081, 0x8000000000008009, 0x000000000000008A,
          0x0000000000000088, 0x0000000080008009, 0x000000008000000A,
          0x000000008000808B, 0x800000000000008B, 0x8000000000008089,
          0x8000000000008003, 0x8000000000008002, 0x8000000000000080,
          0x000000000000800A, 0x800000008000000A, 0x8000000080008081,
          0x8000000000008080, 0x0000000080000001, 0x8000000080008008]
  
    # rotation offsets
    R = [[ 0, 36,  3, 41, 18], [ 1, 44, 10, 45,  2],
         [62,  6, 43, 15, 61], [28, 55, 25, 21, 56],
         [27, 20, 39,  8, 14]]

    # iteration for 5x5 martix
    MATRIX_ITER = lambda {|block| (0...5).each {|x| (0...5).each {|y| block.call(x, y) } } }

    def set_b (b)
      if not [25, 50, 100, 200, 400, 800, 1600].include? b
        raise "b value not supported - use 25, 50, 100, 200, 400, 800, or 1600"
      end

      @b = b
      @w = b / 25
    end

    def rot (x, n)
      # bitwise rotation (to the left) of n bits considering the string of bits is w bits long
      ((x >> (@w - (n % @w))) + (x << (n % @w))) % (1 << @w)
    end

    def from_hex_string_to_lane (string)
      # convert a string of bytes written in hex to a lane value
      # example: string = "5f085c1f91f2e5eb", returns 0xebe5f2911f5c085f
      raise "The provided string does not end with a full byte" if not (string.length % 2) == 0
      string.chars.each_slice(2).to_a.reverse.join.to_i(16)
    end

    def from_lane_to_hex_string (lane)
      # convert a lane value to a string of bytes written in hex
      # example: lane = 899931b4c7c6a6d, returns "6d6a7c4c1b939908"
      lane.to_s(16).rjust((@w / 4), "0").scan(/../).reverse.join
    end

    def convert_string_to_table (string)
      # convert a string of bytes to its 5x5 matrix representation
      # string: string of bytes of hex-coded bytes (e.g. "9A2C....")
      raise "w is not a multiple of 8" if not (@w % 8) == 0
      raise "string can't be divided in 25 blocks of w bits, i.e. string must have exactly b bits" if not string.length == (2 * @b / 8)
      seglen = (2 * @w / 8)
      string.chars.each_slice(seglen * 5).map{|r| r.each_slice(seglen).map{|c| from_hex_string_to_lane(c.join) } }.transpose
    end

    def convert_table_to_string (table)
      # convert a 5x5 matrix representation to its string representation
      raise "w is not a multiple of 8" if not (@w % 8) == 0
      raise "table must be 5x5" if not (table.length == 5 and table.select{|c| c.length == 5 }.length == 5)
      table.transpose.map{|r| r.map{|c| from_lane_to_hex_string(c)}.join}.join
    end

    def round (a, rc_fixed)
      # perform one round of computation as defined in the Keccak-f permutation
      # a: current state (5x5 matrix representation)
      # rc_fixed: value of round constant to use (integer)
      b = ([0] * 25).each_slice(5).to_a
      c, d = [0] * 5, [0] * 5

      # Theta step
      (0...5).each {|x| c[x] = a[x].reduce(:^) }
      (0...5).each {|x| d[x] = c[(x - 1) % 5] ^ rot(c[(x + 1) % 5], 1) }
      MATRIX_ITER.call(lambda {|x, y| a[x][y] ^= d[x] })

      # Rho and Pi steps
      MATRIX_ITER.call(lambda {|x, y| b[y][(2*x + 3*y) % 5] = rot(a[x][y], R[x][y]) })

      # Chi step
      MATRIX_ITER.call(lambda {|x, y| a[x][y] = b[x][y] ^ ((~b[(x + 1) % 5][y]) & b[(x + 2) % 5][y]) })

      # Iota step
      a[0][0] ^= rc_fixed

      return a
    end

    def keccak_f (a)
      # perform Keccak-f function on the state A
      # a: 5x5 matrix containing the state
      nr = 12 + (2 * Math.log2(@w).floor)
      (0...nr).each { |i| a = round(a, RC[i] % (1 << @w)) }
      return a
    end

    def pad10star1 (m, n)
      # pad M with the pad10*1 padding rule to reach a length multiple of r bits
      # m: message pair (length in bits, string of hex characters ("9AFC..."))
      # n: length in bits (must be a multiple of 8)
      # Example: pad10star1([60, "BA594E0FB9EBBD30"], 8) # => "BA594E0FB9EBBD93"
      string_len, string = m
      raise "n must be a multiple of 8" if not (n % 8) == 0

      # pad with one '0' to reach correct length (don't know test vectors coding)
      string = "#{string}0" if not (string.length % 2) == 0
      raise "the string is too short to contain the number of bits announced" if string_len > (string.length / 2 * 8)

      nr_bytes_filled = string_len / 8
      nbr_bits_filled = string_len % 8

      byte = (nbr_bits_filled == 0) ? 0 : string[(nr_bytes_filled*2)...(nr_bytes_filled*2+2)].to_i(16)
      byte >>= (8 - nbr_bits_filled)
      byte += (2 ** nbr_bits_filled)

      string = string[0...nr_bytes_filled * 2]
      l = string_len % n
      if (n - 8) <= l and l <= (n - 2)
        byte += (2 ** 7)
        return "#{string}#{"%02X" % byte}"
      end

      string = "#{string}#{"%02X" % byte}"
      string = "#{string}00" while ((8 * string.length / 2) % n) < (n - 8)
      return "#{string}80"
    end

    def keccak (m, r=1024, c=576, n=1024)
      # compute the Keccak[r,c,d] sponge function on message M
      # m: message pair (length in bits, string of hex characters ("9AFC..."))
      # r: bitrate in bits (default: 1024)
      # c: capacity in bits (default: 576)
      # n: length of output in bits (default: 1024)
      raise "r must be a multiple of 8 in this implementation" if (r < 0) or not (r % 8) == 0
      raise "output length must be a multiple of 8" if not (n % 8) == 0
  
      set_b(r + c)
      w = (r + c) / 25
  
      # initialize the state
      s = ([0] * 25).each_slice(5).to_a
  
      # padding the message
      p = pad10star1(m, r)
  
      # absorbing phase
      (0...(p.length * 8 / 2 / r)).each do |i|
        pi = convert_string_to_table(p[i*(2*r/8)...(i+1)*(2*r/8)] + "00" * (c / 8))
        MATRIX_ITER.call(lambda {|x, y| s[x][y] ^= pi[x][y] })
        s = keccak_f(s)
      end
  
      # squeezing phase
      z = ""
      output_len = n
      while output_len > 0 do
        string = convert_table_to_string(s)
        z = "#{z}#{string[0...(r*2/8)]}"
        output_len -= r
        keccak_f(s) if output_len > 0
      end
  
      return z[0...(2*n/8)]
    end
end
