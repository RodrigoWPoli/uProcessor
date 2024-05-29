# frozen_string_literal: true

code = []
OPCODES = {
  'nop' => '0000',
  'add' => '0001',
  'addi' => '0010',
  'sub' => '0011',
  'subi' => '0100',
  'cmpi' => '0101',
  'ld' => '0110',
  'lda' => '0111',
  'or' => '1000',
  'mult' => '1001',
  'mov' => '1010',
  'mova' => '1011',
  'jump' => '1100',
  'beq' => '1101',
  'blt' => '1110'
}.freeze
REGISTERS = {
  'r0' => '000',
  'r1' => '001',
  'r2' => '010',
  'r3' => '011',
  'r4' => '100',
  'r5' => '101',
  'r6' => '110',
  'r7' => '111'
}.freeze

OIMM = %w[addi subi lda].freeze
ORX = %w[add sub mov mova or mult cmpi].freeze
JMPS = %w[jump beq blt].freeze

def nop(*)
  '0000000000000000'
end

def orx(line)
  instr = line.split.each_with_index.map do |word, index|
    case index
    when 0
      OPCODES[word]
    when 1
      REGISTERS[word]
    end
  end.join
  [instr, '000000000'].join
end

def oimm(line)
  line.split.each_with_index.map do |word, index|
    case index
    when 0
      OPCODES[word]
    when 1
      format('%012b', word.to_i)
    end
  end.join
end

def ld(line)
  line.split.each_with_index.map do |word, index|
    case index
    when 0
      OPCODES[word]
    when 1
      REGISTERS[word]
    when 2
      format('%09b', word.to_i)
    end
  end.join
end

def jump(line)
  instr = line.split.each_with_index.map do |word, index|
    case index
    when 0
      OPCODES[word]
    when 1
      num = word.to_i
      if num.negative?
        format('%07b', (num & 0b1111111))
      else
        format('%07b', num)
      end
    end
  end.join
  [instr, '00000'].join
end

puts 'compiling to machine code following commands:'
previous_instruction = nil
File.readlines('assembly.txt').each_with_index do |line, i|
  puts line.downcase
  opcode = line.split[0].downcase

  if %w[beq blt].include?(opcode) && previous_instruction != 'cmpi'
    raise "Error at line #{i + 1}: #{opcode} instruction without a preceding cmpi instruction"
  end

  code[i] = nop if opcode == 'nop'
  code[i] = orx(line.downcase) if ORX.include?(opcode)
  code[i] = oimm(line.downcase) if OIMM.include?(opcode)
  code[i] = ld(line.downcase) if opcode == 'ld'
  code[i] = jump(line.downcase) if JMPS.include?(opcode)

  previous_instruction = opcode
end

puts 'rom constant:'
puts 'constant rom_content : mem := ('
code.each_with_index do |binary, i|
  puts "\t#{i} => \"#{binary}\","
end
puts "\tothers => (others => '0')"
puts ');'
