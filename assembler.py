OPCODES = {
    'nop': '0000',
    'add': '0001',
    'addi': '0010',
    'sub': '0011',
    'subi': '0100',
    'cmp': '0101',
    'ld': '0110',
    'lw': '0111',
    'or': '1000',
    'mult': '1001',
    'mov': '1010',
    'sw': '1011',
    'jump': '1100',
    'beq': '1101',
    'blt': '1110'
}

REGISTERS = {
    'r0': '000',
    'r1': '001',
    'r2': '010',
    'r3': '011',
    'r4': '100',
    'r5': '101',
    'r6': '110',
    'r7': '111'
}

OIMM = ['addi', 'subi']
ORX = ['add', 'sub', 'or', 'mult', 'cmp', 'lw', 'sw']
MOV = ['mov', 'mova']
JMPS = ['jump', 'beq', 'blt']
LOAD = ['ld']


def to_signed_binary(number, size):
    if number >= 0:
        return format(number, f'0{size}b')
    else:
        return format((1 << size) + number, f'0{size}b')

def nop(*args):
    return '0000000000000000'

def orx(line):
    valid_line(line, 2)
    words = line.split()
    check_register(words[1])
    instr = ''.join([OPCODES[word] if i == 0 else REGISTERS[word] for i, word in enumerate(words)])
    return instr + '000000000'

def oimm(line):
    valid_line(line, 2)
    words = line.split()
    check_max_value(int(words[1]), 12)
    return ''.join([OPCODES[word] if i == 0 else to_signed_binary(int(word), 12) for i, word in enumerate(words)])

def mov(line):
    words = line.split()
    if words[1].lower() == 'a':
        check_register(words[2])
        valid_line(line, 3)
        instr = ''.join([OPCODES[word] if i == 0 else REGISTERS[word] for i, word in enumerate(words) if i != 1])
        return instr + '100000000'
    else:
        check_register(words[1])
        valid_line(line, 2)
        instr = ''.join([OPCODES[word] if i == 0 else REGISTERS[word] for i, word in enumerate(words)])
        return instr + '000000000'

def ld(line):
    valid_line(line, 3)
    words = line.split()
    check_max_value(int(words[2]), 8)
    if words[1].lower() == 'a':
        return ''.join([OPCODES[word] if i == 0 else '000' if i == 1 else '1' + to_signed_binary(int(word), 8) for i, word in enumerate(words)])
    else:
        check_register(words[1])
        return ''.join([OPCODES[word] if i == 0 else REGISTERS[word] if i == 1 else '0' + to_signed_binary(int(word), 8) for i, word in enumerate(words)])

def jump(line):
    valid_line(line, 2)
    words = line.split()
    check_max_value(int(words[1]), 7)
    instr = ''.join([OPCODES[word] if i == 0 else to_signed_binary(int(word), 7) for i, word in enumerate(words)])
    return instr + '00000'

    

def valid_line(line, size):
    if len(line.split()) != size:
        raise ValueError(f"Error: Invalid number of words in {line.split()[0]}. Expected {size} words.")

def cmp_valid(opcode, previous_instruction):
    return opcode in ['beq', 'blt'] and previous_instruction != 'cmp'

def check_max_value(value, bits):
    max_value = 2**(bits - 1) - 1
    min_value = -2**(bits - 1)
    if value > max_value or value < min_value:
        raise ValueError(f"Error: Value {value} is outside the range of {bits} bits for signed integers: {min_value} to {max_value}")
    
def check_register(register):
    if register not in REGISTERS:
        raise ValueError(f"Error: Invalid register {register}")

def process_opcode(opcode, line):
    match opcode:
        case 'nop':
            return nop()
        case _ if opcode in ORX:
            return orx(line)
        case _ if opcode in OIMM:
            return oimm(line)
        case _ if opcode in LOAD:
            return ld(line)
        case _ if opcode in JMPS:
            return jump(line)
        case _ if opcode in MOV:
            return mov(line)
        case _:
            raise ValueError(f"Error: Invalid opcode {opcode}")

def compile(file_name):
    code = []
    command = []
    previous_instruction = None
    with open(file_name, 'r') as f:
        for i, line in enumerate(f):
            line = line.strip()
            command.append(line)
            line = line.replace(',', '')
            if not line:
                continue
            opcode = line.split()[0].lower()
            if cmp_valid(opcode, previous_instruction):
                raise ValueError(f"Error at line {i + 1}: {opcode} instruction without a preceding cmp instruction")
            code.append(process_opcode(opcode, line.lower()))
            previous_instruction = opcode
    save_to_rom(code, command)

    
def save_to_rom(code, command, filename='rtl/rom.vhd'):
    with open(filename, 'w') as f:
        f.write('library ieee;\n')
        f.write('use ieee.std_logic_1164.all;\n')
        f.write('use ieee.numeric_std.all;\n')
        f.write('entity rom is\n')
        f.write('  port\n')
        f.write('  (\n')
        f.write('    clk     : in std_logic;\n')
        f.write('    address : in unsigned(6 downto 0);\n')
        f.write('    data    : out unsigned(15 downto 0)\n')
        f.write('  );\n')
        f.write('end entity;\n')
        f.write('architecture rtl of rom is\n')
        f.write('  type mem is array (0 to 127) of unsigned(15 downto 0);\n')
        f.write('  constant rom_content : mem := (\n')
        
        for i, binary in enumerate(code):
            f.write(f'        {i} => "{binary}", --{command[i]}\n')

        f.write('        others => (others => \'0\')\n')
        f.write('  );\n')
        f.write('begin\n')
        f.write('  process (clk)\n')
        f.write('  begin\n')
        f.write('    if (rising_edge(clk)) then\n')
        f.write('      data <= rom_content(to_integer(address));\n')
        f.write('    end if;\n')
        f.write('  end process;\n')
        f.write('end architecture;\n')

if __name__ == "__main__":
    compile('assembly.txt')
