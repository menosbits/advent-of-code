package challenges

import "aoc:utils"
import "core:fmt"
import vmem "core:mem/virtual"
import "core:strings"
import "core:testing"

three :: proc() -> (uint, uint) {
	arena: vmem.Arena
	arena_err := vmem.arena_init_growing(&arena)
	if arena_err != nil {
		fmt.eprintfln("[D3!] error initializing arena allocator: %s", arena_err)
		return 0, 0
	}
	arena_allocator := vmem.arena_allocator(&arena)
	defer vmem.arena_destroy(&arena)
	fcontent, err := utils.load_input("three", arena_allocator)
	if err != nil {
		fmt.eprintfln("[D3!] error opening input file: %s", err)
		return 0, 0
	}
	banks: []string
	banks, err = strings.split_lines(fcontent, arena_allocator)
	if err != nil {
		fmt.eprintfln("[D3!] error splitting file content: %s", err)
		return 0, 0
	}
	return part_one(banks), part_two(banks)
}

@(private = "file")
part_one :: proc(banks: []string) -> uint {
	result: uint = 0
	for bank in banks {
		best: uint = 0
		for i := 0; i < len(bank) - 1; i += 1 {
			first_digit := uint(bank[i] - '0')
			second_digit: uint = 0
			for j := i + 1; j < len(bank); j += 1 {
				digit := uint(bank[j] - '0')
				if digit > second_digit do second_digit = digit
			}
			candidate := first_digit * 10 + second_digit
			if candidate > best do best = candidate
		}
		result += best
	}
	return result
}

@(test)
day_three_part_one_test :: proc(t: ^testing.T) {
	arena: vmem.Arena
	arena_err := vmem.arena_init_growing(&arena)
	if arena_err != nil {
		fmt.eprintfln("[TD3P1!] error initializing arena allocator: %s", arena_err)
		testing.fail(t)
	}
	arena_allocator := vmem.arena_allocator(&arena)
	defer vmem.arena_destroy(&arena)
	fcontent, err := utils.load_input("three_test", arena_allocator)
	if err != nil {
		fmt.eprintfln("[TD3P1!] error opening input file: %s", err)
		testing.fail(t)
	}
	banks: []string
	banks, err = strings.split_lines(fcontent, arena_allocator)
	if err != nil {
		fmt.eprintfln("[TD3P1!] error splitting file content: %s", err)
		testing.fail(t)
	}
	expected: uint = 357
	got := part_one(banks)
	testing.expectf(t, got == expected, "got: %d, expected: %d", got, expected)
}

@(private = "file")
part_two :: proc(banks: []string) -> uint {
	result: uint = 0
	for bank in banks {
		best: uint = 0
		last_index := 0
		for n := 11; n >= 0; n -= 1 {
			candidate: uint = 0
			for i := last_index; i < len(bank) - n; i += 1 {
				digit := uint(bank[i] - '0')
				if digit > candidate {
					candidate = digit
					last_index = i + 1
				}
			}
			best = best * 10 + candidate
		}
		result += best
	}
	return result
}

@(test)
day_three_part_two_test :: proc(t: ^testing.T) {
	arena: vmem.Arena
	arena_err := vmem.arena_init_growing(&arena)
	if arena_err != nil {
		fmt.eprintfln("[TD3P2!] error initializing arena allocator: %s", arena_err)
		testing.fail(t)
	}
	arena_allocator := vmem.arena_allocator(&arena)
	defer vmem.arena_destroy(&arena)
	fcontent, err := utils.load_input("three_test", arena_allocator)
	if err != nil {
		fmt.eprintfln("[TD3P2!] error opening input file: %s", err)
		testing.fail(t)
	}
	banks: []string
	banks, err = strings.split_lines(fcontent, arena_allocator)
	if err != nil {
		fmt.eprintfln("[TD3P2!] error splitting file content: %s", err)
		testing.fail(t)
	}
	expected: uint = 3121910778619
	got := part_two(banks)
	testing.expectf(t, got == expected, "got: %d, expected: %d", got, expected)
}
