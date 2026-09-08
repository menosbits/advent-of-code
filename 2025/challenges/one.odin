package challenges

import "aoc:utils"
import "core:fmt"
import vmem "core:mem/virtual"
import "core:strconv"
import "core:strings"
import "core:testing"

one :: proc() -> (uint, uint) {
	arena: vmem.Arena
	arena_err := vmem.arena_init_growing(&arena)
	if arena_err != nil {
		fmt.eprintfln("[D1!] error initializing arena: %s", arena_err)
		return 0, 0
	}
	arena_allocator := vmem.arena_allocator(&arena)
	defer vmem.arena_destroy(&arena)
	fcontent, err := utils.load_input("one", arena_allocator)
	if err != nil {
		fmt.eprintfln("[D1!] error opening input file: %s", err)
		return 0, 0
	}
	instructions := parse_input(fcontent, arena_allocator)
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
part_one :: proc(instructions: []Dial) -> uint {
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
	arena: vmem.Arena
	arena_err := vmem.arena_init_growing(&arena)
	if arena_err != nil {
		fmt.eprintfln("[TD1P1!] error initializing arena: %s", arena_err)
		testing.fail(t)
	}
	arena_allocator := vmem.arena_allocator(&arena)
	defer vmem.arena_destroy(&arena)
	fcontent, err := utils.load_input("one_test", arena_allocator)
	if err != nil {
		fmt.eprintfln("[TD1P1!] error opening input file: %s", err)
		testing.fail(t)
	}
	instructions := parse_input(fcontent, arena_allocator)
	expected: uint = 3
	got := part_one(instructions)
	testing.expectf(t, expected == got, "got: %d, expected: %d", got, expected)
}

@(private = "file")
part_two :: proc(instructions: []Dial) -> uint {
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
	arena: vmem.Arena
	arena_err := vmem.arena_init_growing(&arena)
	if arena_err != nil {
		fmt.eprintfln("[TD1P2!] error initializing arena: %s", arena_err)
		testing.fail(t)
	}
	arena_allocator := vmem.arena_allocator(&arena)
	defer vmem.arena_destroy(&arena)
	fcontent, err := utils.load_input("one_test", arena_allocator)
	if err != nil {
		fmt.eprintfln("[TD1P2!] error opening input file: %s", err)
		testing.fail(t)
	}
	instructions := parse_input(fcontent, arena_allocator)
	expected: uint = 6
	got := part_two(instructions)
	testing.expectf(t, expected == got, "got: %d, expected: %d", got, expected)
}

@(private = "file")
parse_input :: proc(input: string, allocator := context.allocator) -> []Dial {
	input := input
	parsed_input := make([dynamic]Dial, allocator)
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
			fmt.eprintfln("[D1!] error converting %s to uint", line[1:])
			break
		}
		dial := Dial {
			direction = direction,
			distance  = distance,
		}
		_, err := append(&parsed_input, dial)
		if err != nil {
			fmt.eprintfln("[D1!] error appending %v: %s", dial, err)
			break
		}
	}
	return parsed_input[:]
}
