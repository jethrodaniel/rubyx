require_relative 'helper'

class TestWhileFragment < MiniTest::Test
  include Fragments

  def test_while
    @string_input = <<HERE
    def fibonaccit(n) # n == r0
      a = 0           # a == r1
      b = 1           # b = r2
      while( n > 1 ) do                   #BUG comment lines + comments behind function calls
        tmp = a       # r3 <- r1
        a = b         # r1 <- r2
        b = tmp + b   #  r4 = r2 + r3  (r4 transient)  r2 <- r4 
        n = n - 1      # r0 <- r2   for call,    #call ok  
      end             #r5 <- r0 - 1    n=n-1 through r5 tmp              
      putint(b)
    end               # r0 <- r5

    fibonaccit( 10 )
HERE
    @should = [0x0,0xb0,0xa0,0xe3,0xa,0x10,0xa0,0xe3,0x2,0x0,0x0,0xeb,0x1,0x70,0xa0,0xe3,0x0,0x0,0x0,0xef,0x0,0x70,0xa0,0xe1,0x0,0x40,0x2d,0xe9,0x0,0x20,0xa0,0xe3,0x1,0x30,0xa0,0xe3,0x1,0x0,0x51,0xe3,0x6,0x0,0x0,0xda,0x2,0x40,0xa0,0xe1,0x3,0x20,0xa0,0xe1,0x3,0x50,0x84,0xe0,0x5,0x30,0xa0,0xe1,0x1,0x60,0x41,0xe2,0x6,0x10,0xa0,0xe1,0xf6,0xff,0xff,0xea,0x7e,0x0,0x2d,0xe9,0x3,0x10,0xa0,0xe1,0x12,0x0,0x0,0xeb,0x7e,0x0,0xbd,0xe8,0x0,0x80,0xbd,0xe8,0x0,0x40,0x2d,0xe9,0xa,0x30,0x42,0xe2,0x22,0x21,0x42,0xe0,0x22,0x22,0x82,0xe0,0x22,0x24,0x82,0xe0,0x22,0x28,0x82,0xe0,0xa2,0x21,0xa0,0xe1,0x2,0x41,0x82,0xe0,0x84,0x30,0x53,0xe0,0x1,0x20,0x82,0x52,0xa,0x30,0x83,0x42,0x30,0x30,0x83,0xe2,0x0,0x30,0xc1,0xe5,0x1,0x10,0x41,0xe2,0x0,0x0,0x52,0xe3,0xef,0xff,0xff,0x1b,0x0,0x80,0xbd,0xe8,0x0,0x40,0x2d,0xe9,0x1,0x20,0xa0,0xe1,0x20,0x10,0x8f,0xe2,0x9,0x10,0x81,0xe2,0xe9,0xff,0xff,0xeb,0x14,0x10,0x8f,0xe2,0xc,0x20,0xa0,0xe3,0x1,0x0,0xa0,0xe3,0x4,0x70,0xa0,0xe3,0x0,0x0,0x0,0xef,0x0,0x70,0xa0,0xe1,0x0,0x80,0xbd,0xe8,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20]
    @output = "        55  "
    parse
    write "while"
  end
end

