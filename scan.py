import os
import re

def find_missing_files(directory):
    for root, _, files in os.walk(directory):
        mp3_files = [f for f in files if f.endswith('.mp3')]
        file_numbers = []

        for file in mp3_files:
            match = re.match(r'(\d{2})', file)
            if match:
                file_numbers.append(int(match.group(1)))

        if file_numbers:
            file_numbers.sort()
            missing_files = [f'{i:02}' for i in range(file_numbers[0], file_numbers[-1] + 1) if i not in file_numbers]

            if missing_files:
                print(f"Missing files in directory {root}: {', '.join(missing_files)}")

if __name__ == "__main__":
    current_directory = os.path.dirname(os.path.abspath(__file__))
    find_missing_files(current_directory)
