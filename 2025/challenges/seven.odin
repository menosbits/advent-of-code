package challenges

import "aoc:utils"
import "core:fmt"
import "core:slice"
import "core:strings"
import "core:testing"

seven :: proc() -> (uint, uint) {
	fcontent, err := utils.load_input("seven")
	if err != nil {
		fmt.eprintfln("[D7!] error opening input file: %s", err)
		return 0, 0
	}
	defer delete(fcontent)
	return part_one(fcontent), part_two(fcontent)
}

@(private = "file")
part_one :: proc(input: string) -> uint {
	result: uint
	input := input
	beam_indexes := make([dynamic]u8)
	defer delete(beam_indexes)
	for line in strings.split_lines_iterator(&input) {
		for i := 0; i < len(line); i += 1 {
			switch line[i] {
			case 'S':
				append_elem(&beam_indexes, u8(i))
				continue
			case '^':
				for slice.contains(beam_indexes[:], u8(i)) {
					index, ok := slice.linear_search(beam_indexes[:], u8(i))
					if ok {
						result += 1
						unordered_remove(&beam_indexes, index)
						if !slice.contains(beam_indexes[:], u8(i) - 1) && i > 0 {
							append_elem(&beam_indexes, u8(i) - 1)
						}
						if !slice.contains(beam_indexes[:], u8(i) + 1) && i + 1 < len(line) {
							append_elem(&beam_indexes, u8(i) + 1)
						}
					}
				}
			case '.':
				continue
			}
		}
	}
	return result
}

@(test)
day_seven_part_one_test :: proc(t: ^testing.T) {
	fcontent, err := utils.load_input("seven_test")
	if err != nil {
		fmt.eprintfln("[TD7P1!] error opening input file: %s", err)
		testing.fail(t)
	}
	defer delete(fcontent)
	got := part_one(fcontent)
	expected: uint = 21
	testing.expectf(t, got == expected, "got: %d, expected: %d", got, expected)
}

@(private = "file")
part_two :: proc(input: string) -> uint {
	result: uint
	return result
}

@(test)
day_seven_part_two_test :: proc(t: ^testing.T) {
	fcontent, err := utils.load_input("seven_test")
	if err != nil {
		fmt.eprintfln("[TD7P2!] error opening input file: %s", err)
		testing.fail(t)
	}
	defer delete(fcontent)
	got := part_two(fcontent)
	expected: uint = 40
	testing.expectf(t, got == expected, "got: %d, expected: %d", got, expected)
}
