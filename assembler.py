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
ORX = ['add', 'sub', 'or', 'mult', 'cmp']
MOV = ['mov', 'mova']
JMPS = ['jump', 'beq', 'blt']
LOAD = ['ld']
RAM = ['lw', 'sw']


def to_signed_binary(number, size):
    if number >= 0:
        return format(number, f'0{size}b')
    else:
        return format((1 << size) + number, f'0{size}b')

def nop(*args):
    return '0000000000000000'

def orx(line):
    valid_line(line, 2)
    instr = ''.join([OPCODES[word] if i == 0 else REGISTERS[word] for i, word in enumerate(line.split())])
    return instr + '000000000'

def oimm(line):
    valid_line(line, 2)
    check_max_value(int(line.split()[1]), 12)
    return ''.join([OPCODES[word] if i == 0 else to_signed_binary(int(word), 12) for i, word in enumerate(line.split())])

def mov(line):
    words = line.split()
    if words[1].lower() == 'a':
        valid_line(line, 3)
        instr = ''.join([OPCODES[word] if i == 0 else REGISTERS[word] for i, word in enumerate(words) if i != 1])
        return instr + '100000000'
    else:
        valid_line(line, 2)
        instr = ''.join([OPCODES[word] if i == 0 else REGISTERS[word] for i, word in enumerate(words)])
        return instr + '000000000'

def ld(line):
    valid_line(line, 3)
    check_max_value(int(line.split()[2]), 8)
    words = line.split()
    if words[1].lower() == 'a':
        return ''.join([OPCODES[word] if i == 0 else '000' if i == 1 else '1' + to_signed_binary(int(word), 8) for i, word in enumerate(words)])
    else:
        return ''.join([OPCODES[word] if i == 0 else REGISTERS[word] if i == 1 else '0' + to_signed_binary(int(word), 8) for i, word in enumerate(words)])

def jump(line):
    valid_line(line, 2)
    check_max_value(int(line.split()[1]), 7)
    instr = ''.join([OPCODES[word] if i == 0 else to_signed_binary(int(word), 7) for i, word in enumerate(line.split())])
    return instr + '00000'

def ram(line):
    valid_line(line, 3)
    check_max_value(int(line.split()[2]), 7)
    instr = ''.join([OPCODES[word] if i == 0 else REGISTERS[word] if i == 1 else to_signed_binary(int(word), 7) for i, word in enumerate(line.split())])
    return instr + '00'
    

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


def compile_to_machine_code(file_name):
    code = []
    previous_instruction = None
    with open(file_name, 'r') as f:
        for i, line in enumerate(f):
            line = line.strip()
            if not line:
                continue
            print(line.lower())
            opcode = line.split()[0].lower()
            if cmp_valid(opcode, previous_instruction):
                raise ValueError(f"Error at line {i + 1}: {opcode} instruction without a preceding cmp instruction")
            code.append(process_opcode(opcode, line.lower()))
            previous_instruction = opcode
    return code

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
        case _ if opcode in RAM:
            return ram(line)
        case _:
            raise ValueError(f"Error: Invalid opcode {opcode}")

def generate_rom_constant(code):
    print('rom constant:')
    print('constant rom_content : mem := (')
    for i, binary in enumerate(code):
        print(f"\t{i} => \"{binary}\",")
    print("\tothers => (others => '0')")
    print(');')

if __name__ == "__main__":
    code = compile_to_machine_code('assembly.txt')
    generate_rom_constant(code)
