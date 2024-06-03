import random

def generate_ram_line():
    first_word = random.choice(['lw', 'sw'])
    second_word = f"R{random.randint(0, 7)}"
    
    return f"{first_word} {second_word}"

def generate_acum_line():
    third_word = random.randint(-128, 127)

    return f"ld a {third_word}"

def generate_lines(n):
    lines = []
    for i in range(n):
        if i % 2 == 0:
            lines.append(generate_acum_line())
        else:
            line = generate_ram_line()
            if line.startswith('lw'):
                lines.append(line)
                lines.append(generate_mov_line())
            else:
                lines.append(line)
    return lines


def generate_mov_line():
    second_word = f"R{random.randint(0, 7)}"
    return f"mov {second_word}"

if __name__ == "__main__":
    num_lines = 100
    lines = generate_lines(num_lines)
    
    for line in lines:
        print(line)
