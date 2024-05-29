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
  'jump' => '1100'
}.freeze
REGISTERS = {
  'R0' => '000',
  'R1' => '001',
  'R2' => '010',
  'R3' => '011',
  'R4' => '100',
  'R5' => '101',
  'R6' => '110',
  'R7' => '111'
}.freeze

OIMM = %w[addi subi cmpi lda].freeze
ORX = %w[add sub mov mova or mult].freeze

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
      format('%07b', word.to_i)
    end
  end.join
  [instr, '00000'].join
end

File.readlines('assembly.txt').each_with_index do |line, i|
  opcode = line.split[0]
  code[i] = nop if opcode == 'nop'
  code[i] = orx(line) if ORX.include?(opcode)
  code[i] = oimm(line) if OIMM.include?(opcode)
  code[i] = ld(line) if 'ld'.include?(opcode)
  code[i] = jump(line) if 'jump'.include?(opcode)
end

puts 'constant rom_content : mem := ('
code.each_with_index do |binary, i|
  puts "\t#{i} => \"#{binary}\","
end
puts "\tothers => (others => '0')"
puts ');'
