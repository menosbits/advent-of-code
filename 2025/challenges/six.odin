package challenges

import "aoc:utils"
import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:testing"

six :: proc() -> (uint, uint) {
	fcontent, err := utils.load_input("six")
	if err != nil {
		fmt.eprintfln("[D6!] error opening input file: %s", err)
		return 0, 0
	}
	defer delete(fcontent)
	return part_one(fcontent), part_two(fcontent)
}

@(private = "file")
part_one :: proc(input: string) -> uint {
	input := input
	parsed_input := make([dynamic][]string)
	defer delete(parsed_input)
	line_index := 0
	for line in strings.split_lines_iterator(&input) {
		splitted_line, err := strings.split(line, " ")
		defer delete(splitted_line)
		if err != nil {
			fmt.eprintfln("[D6!] error splitting line: %s", err)
			return 0
		}
		parsed_line := make([dynamic]string)
		for elem_value, elem_index in splitted_line {
			if elem_value == "" do continue
			_, err := append(&parsed_line, elem_value)
			if err != nil {
				fmt.eprintfln("[D6!] error appending line to array: %s", err)
				return 0
			}
		}
		_, err = append(&parsed_input, parsed_line[:])
		if err != nil {
			fmt.eprintfln("[D6!] error appending line to array: %s", err)
			return 0
		}
		line_index += 1
	}
	result: uint
	input_len := len(parsed_input)
	line_len := len(parsed_input[0])
	for i := 0; i < line_len; i += 1 {
		partial_result: uint
		for j := 0; j < input_len - 1; j += 1 {
			number, ok := strconv.parse_uint(parsed_input[j][i], 10)
			if !ok {
				fmt.eprintfln("[D6P1!] error parsing %s to uint", parsed_input[j][i])
				return 0
			}
			operator := parsed_input[input_len - 1][i]
			switch operator {
			case "+":
				partial_result += number
			case "*":
				if j == 0 do partial_result = 1
				partial_result *= number
			}
		}
		result += partial_result
	}
	for line in parsed_input do delete(line)
	return result
}

@(test)
day_six_part_one_test :: proc(t: ^testing.T) {
	fcontent, err := utils.load_input("six_test")
	if err != nil {
		fmt.eprintfln("[TD6P1!] error opening input file: %s", err)
		testing.fail(t)
	}
	defer delete(fcontent)
	expected: uint = 4277556
	got := part_one(fcontent)
	testing.expectf(t, expected == got, "got: %d, expected: %d", got, expected)
}

@(private = "file")
part_two :: proc(input: string) -> uint {
	result: uint
	lines, err := strings.split_lines(input)
	defer delete(lines)
	if err != nil {
		fmt.eprintfln("[D6P2!] error splitting input lines: %s", err)
		return 0
	}
	blank_lines: uint
	numbers := make([dynamic]uint)
	defer delete(numbers)
	line_for: for i := len(lines[0]) - 1; i >= 0; i -= 1 {
		column_number: uint = 0
		for j := 0; j < len(lines) - 1; j += 1 {
			switch lines[j][i] {
			case ' ':
				blank_lines += 1
				continue
			case '0' ..= '9':
				blank_lines = 0
				n, ok := strconv.parse_uint(fmt.tprintf("%c", lines[j][i]))
				if !ok {
					fmt.eprintfln("[D6P2!] error parsing %s to uint", lines[j][i])
					return 0
				}
				if column_number == 0 do column_number += n
				else do column_number = column_number * 10 + n
			}
		}
		if blank_lines != len(lines) - 1 || i == 0 {
			blank_lines = 0
			_, err := append(&numbers, column_number)
			if err != nil {
				fmt.eprintfln("[D6!] error appending line to array: %s", err)
				return 0
			}
		}
		if blank_lines == len(lines) - 1 || i == 0 {
			blank_lines = 0
			operator := lines[len(lines) - 1][i + 1] if i != 0 else lines[len(lines) - 1][i]
			switch operator {
			case '+':
				partial_result: uint = 0
				for n in numbers do partial_result += n
				result += partial_result
				delete(numbers)
				numbers = make([dynamic]uint)
				continue line_for
			case '*':
				partial_result: uint = 1
				for n in numbers do partial_result *= n
				result += partial_result
				delete(numbers)
				numbers = make([dynamic]uint)
				continue line_for
			}
		}
	}
	return result
}

@(test)
day_six_part_two_test :: proc(t: ^testing.T) {
	fcontent, err := utils.load_input("six_test")
	if err != nil {
		fmt.eprintfln("[TD6P2!] error opening input file: %s", err)
		testing.fail(t)
	}
	defer delete(fcontent)
	expected: uint = 3263827
	got := part_two(fcontent)
	testing.expectf(t, expected == got, "got: %d, expected: %d", got, expected)
}
