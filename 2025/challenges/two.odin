package challenges

import "aoc:utils"
import "core:fmt"
import vmem "core:mem/virtual"
import "core:strconv"
import "core:strings"
import "core:testing"

two :: proc() -> (uint, uint) {
	arena: vmem.Arena
	arena_err := vmem.arena_init_growing(&arena)
	if arena_err != nil {
		fmt.eprintfln("[D2!] error initializing arena: %s", arena_err)
		return 0, 0
	}
	arena_allocator := vmem.arena_allocator(&arena)
	defer vmem.arena_destroy(&arena)
	fcontent, err := utils.load_input("two", arena_allocator)
	if err != nil {
		fmt.eprintfln("[D2!] error opening input file: %s", err)
		return 0, 0
	}
	ranges := parse_input(fcontent, arena_allocator)
	return part_one(ranges), part_two(ranges)
}

@(private = "file")
Range :: struct {
	start: uint,
	end:   uint,
}

@(private = "file")
part_one :: proc(ranges: []Range) -> uint {
	result: uint = 0
	for range in ranges {
		for i := range.start; i <= range.end; i += 1 {
			buf := make([]byte, 20)
			defer delete(buf)
			str_i := strconv.write_uint(buf, u64(i), 10)
			if str_i[:len(str_i) / 2] == str_i[len(str_i) / 2:] {
				result += i
			}
		}
	}
	return result
}

@(test)
day_two_part_one_test :: proc(t: ^testing.T) {
	arena: vmem.Arena
	arena_err := vmem.arena_init_growing(&arena)
	if arena_err != nil {
		fmt.eprintfln("[TD2P1!] error initializing arena: %s", arena_err)
		testing.fail(t)
	}
	arena_allocator := vmem.arena_allocator(&arena)
	defer vmem.arena_destroy(&arena)
	fcontent, err := utils.load_input("two_test", arena_allocator)
	if err != nil {
		fmt.eprintfln("[TD2P1!] error opening input file: %s", err)
		testing.fail(t)
	}
	ranges := parse_input(fcontent, arena_allocator)
	expected: uint = 1227775554
	got := part_one(ranges)
	testing.expectf(t, expected == got, "expected: %d, got: %d", expected, got)
}

@(private = "file")
part_two :: proc(ranges: []Range) -> uint {
	result: uint = 0
	for range in ranges {
		for i := range.start; i <= range.end; i += 1 {
			buf := make([]byte, 20)
			defer delete(buf)
			str_i := strconv.write_uint(buf, u64(i), 10)
			double_str_i, err := strings.repeat(str_i, 2)
			if err != nil {
				fmt.eprintfln("[D2P2!] Could not concatenate %s: %s", str_i, err)
				return 0
			}
			defer delete(double_str_i)
			if strings.contains(double_str_i[1:len(double_str_i) - 1], str_i) do result += i
		}
	}
	return result
}

@(test)
day_two_part_two_test :: proc(t: ^testing.T) {
	arena: vmem.Arena
	arena_err := vmem.arena_init_growing(&arena)
	if arena_err != nil {
		fmt.eprintfln("[TD2P2!] error initializing arena: %s", arena_err)
		testing.fail(t)
	}
	arena_allocator := vmem.arena_allocator(&arena)
	defer vmem.arena_destroy(&arena)
	fcontent, err := utils.load_input("two_test", arena_allocator)
	if err != nil {
		fmt.eprintfln("[TD2P2!] error opening input file: %s", err)
		testing.fail(t)
	}
	ranges := parse_input(fcontent, arena_allocator)
	expected: uint = 4174379265
	got := part_two(ranges)
	testing.expectf(t, expected == got, "expected: %d, got: %d", expected, got)
}

@(private = "file")
parse_input :: proc(input: string, allocator := context.allocator) -> []Range {
	parsed_input := make([dynamic]Range, allocator)
	trimmed_input := strings.trim(input, "\n")
	for ranges in strings.split_iterator(&trimmed_input, ",") {
		split_string := strings.split(ranges, "-", allocator)
		start, ok := strconv.parse_uint(split_string[0])
		if !ok {
			fmt.eprintfln("[D2!] error parsing %s to uint", split_string[0])
			break
		}
		end: uint
		end, ok = strconv.parse_uint(split_string[1])
		if !ok {
			fmt.eprintfln("[D2!] error parsing %s to uint", split_string[1])
			break
		}
		new_range := Range {
			start = start,
			end   = end,
		}
		_, err := append(&parsed_input, new_range)
		if err != nil {
			fmt.eprintfln("[D2!] error appending element: %s", err)
			break
		}
	}
	return parsed_input[:]
}
