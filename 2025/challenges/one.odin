package challenges

import "aoc:utils"
import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:testing"

one :: proc() -> (uint, uint) {
	fcontent, err := utils.load_input("one")
	if err != nil {
		fmt.printfln("[D1!] error opening input file: %s", err)
		return 0, 0
	}
	defer delete(fcontent)
	instructions := parse_input(fcontent)
	defer delete(instructions)
	return part_one(instructions), part_two(instructions)
}

@(private = "file")
Dial :: struct {
	direction: Direction,
	distance:  uint,
}

@(private = "file")
Direction :: enum {
	Right,
	Left,
}

@(private = "file")
part_one :: proc(instructions: [dynamic]Dial) -> uint {
	answer: uint = 0
	dial_position: i8 = 50
	for instruction in instructions {
		distance := instruction.distance
		for distance != 0 {
			switch instruction.direction {
			case .Left:
				if dial_position - 1 < 0 {
					dial_position = 99
				} else {
					dial_position -= 1
				}

			case .Right:
				if dial_position + 1 > 99 {
					dial_position = 0
				} else {
					dial_position += 1
				}
			}
			distance -= 1
		}
		if dial_position == 0 {
			answer += 1
		}
	}
	return answer
}

@(test)
day_one_part_one_test :: proc(t: ^testing.T) {
	fcontent, err := utils.load_input("one_test")
	if err != nil {
		fmt.printfln("[TD1P1!] error opening input file: %s", err)
		testing.fail(t)
	}
	defer delete(fcontent)
	instructions := parse_input(fcontent)
	defer delete(instructions)
	expected: uint = 3
	got := part_one(instructions)
	testing.expectf(t, expected == got, "got: %d, expected: %d", got, expected)
}

@(private = "file")
part_two :: proc(instructions: [dynamic]Dial) -> uint {
	answer: uint = 0
	dial_position: i8 = 50
	for instruction in instructions {
		distance := instruction.distance
		for distance != 0 {
			switch instruction.direction {
			case .Left:
				if dial_position - 1 < 0 {
					dial_position = 99
				} else {
					dial_position -= 1
				}

			case .Right:
				if dial_position + 1 > 99 {
					dial_position = 0
				} else {
					dial_position += 1
				}
			}
			if dial_position == 0 {
				answer += 1
			}
			distance -= 1
		}
	}
	return answer
}

@(test)
day_one_part_two_test :: proc(t: ^testing.T) {
	fcontent, err := utils.load_input("one_test")
	if err != nil {
		fmt.printfln("[TD1P2!] error opening input file: %s", err)
		testing.fail(t)
	}
	defer delete(fcontent)
	instructions := parse_input(fcontent)
	defer delete(instructions)
	expected: uint = 6
	got := part_two(instructions)
	testing.expectf(t, expected == got, "got: %d, expected: %d", got, expected)
}

@(private = "file")
parse_input :: proc(input: string) -> [dynamic]Dial {
	input := input
	parsed_input: [dynamic]Dial
	for line in strings.split_iterator(&input, "\n") {
		direction: Direction
		switch line[0] {
		case 'L':
			direction = .Left
		case 'R':
			direction = .Right
		}
		distance, ok := strconv.parse_uint(line[1:])
		if !ok {
			fmt.printfln("[D1!] error converting %s to uint", line[1:])
			break
		}
		dial := Dial {
			direction = direction,
			distance  = distance,
		}
		_, err := append(&parsed_input, dial)
		if err != nil {
			fmt.printfln("[D1!] error appending %v: %s", dial, err)
			break
		}
	}
	return parsed_input
}
