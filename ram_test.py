import random

def generate_line():
    first_word = random.choice(['lw', 'sw'])
    second_word = f"R{random.randint(0, 7)}"
    third_word = random.randint(0, 127)
    
    return f"{first_word} {second_word} {third_word}"

def generate_lines(n):
    lines = [generate_line() for _ in range(n)]
    return lines

if __name__ == "__main__":
    num_lines = 100
    lines = generate_lines(num_lines)
    
    for line in lines:
        print(line)
