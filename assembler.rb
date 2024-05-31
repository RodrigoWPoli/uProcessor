# frozen_string_literal: true

OPCODES = {
  'nop' => '0000',
  'add' => '0001',
  'addi' => '0010',
  'sub' => '0011',
  'subi' => '0100',
  'cmp' => '0101',
  'ld' => '0110',
  'lda' => '0111',
  'or' => '1000',
  'mult' => '1001',
  'mov' => '1010',
  'not_used' => '1011',
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
ORX = %w[add sub or mult cmp].freeze
MOV = %w[mov mova].freeze
JMPS = %w[jump beq blt].freeze
LOAD = %w[ld lda].freeze

def nop(*)
  '0000000000000000'
end

def orx(line)
  valid_line(line, 2)

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
  valid_line(line, 2)

  line.split.each_with_index.map do |word, index|
    case index
    when 0
      OPCODES[word]
    when 1
      format('%012b', word.to_i)
    end
  end.join
end

def mov(line)
  if line.split[1].downcase == 'a'
    valid_line(line, 3)

    instr = line.split.each_with_index.map do |word, index|
      case index
      when 0
        OPCODES[word]
      when 2
        REGISTERS[word]
      end
    end.join
    [instr, '100000000'].join
  else
    instr = line.split.each_with_index.map do |word, index|
      valid_line(line, 2)

      case index
      when 0
        OPCODES[word]
      when 1
        REGISTERS[word]
      end
    end.join
    [instr, '000000000'].join
  end
end

def ld(line)
  valid_line(line, 3)

  if line.split[1].downcase == 'a'
    line.split.each_with_index.map do |word, index|
      case index
      when 0
        OPCODES[word]
      when 1
        '000'
      when 2
        ['1', format('%08b', word.to_i)].join
      end
    end.join
  else
    line.split.each_with_index.map do |word, index|
      case index
      when 0
        OPCODES[word]
      when 1
        REGISTERS[word]
      when 2
        ['0', format('%08b', word.to_i)].join
      end
    end.join
  end
end

def jump(line)
  valid_line(line, 2)

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

def valid_line(line, size)
  raise "Error: Invalid number of words in #{line.split[0]}. Expected 2 words." unless line.split.length == size
end

def cmp_valid?(opcode, previous_instruction)
  %w[beq blt].include?(opcode) && previous_instruction != 'cmp'
end

require 'rubocop'

def compile_to_machine_code(file_name)
  code = []
  previous_instruction = nil
  File.readlines(file_name).each_with_index do |line, i|
    next if line.strip.empty?

    puts line.downcase
    opcode = line.split[0].downcase
    raise "Error at line #{i + 1}: #{opcode} instruction without a preceding cmp instruction" if cmp_valid?(opcode,
                                                                                                            previous_instruction)

    code[i] = process_opcode(opcode, line.downcase)
    previous_instruction = opcode
  end
  code
end

def process_opcode(opcode, line)
  case opcode
  when 'nop'
    nop
  when *ORX
    orx(line)
  when *OIMM
    oimm(line)
  when *LOAD
    ld(line)
  when *JMPS
    jump(line)
  when *MOV
    mov(line)
  else
    raise "Error: Invalid opcode #{opcode}"
  end
end

def generate_rom_constant(code)
  puts 'rom constant:'
  puts 'constant rom_content : mem := ('
  code.each_with_index do |binary, i|
    puts "\t#{i} => \"#{binary}\","
  end
  puts "\tothers => (others => '0')"
  puts ');'
end

code = compile_to_machine_code('assembly.txt')
generate_rom_constant(code)
