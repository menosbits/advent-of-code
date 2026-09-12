package challenges

import "aoc:utils"
import "core:fmt"
import "core:sort"
import "core:strconv"
import "core:strings"
import "core:testing"

five :: proc() -> (uint, uint) {
	fcontent, err := utils.load_input("five")
	if err != nil {
		fmt.printfln("[D5!] error opening input file: %s", err)
		return 0, 0
	}
	defer delete(fcontent)
	ingredients, ranges := parse_input(fcontent)
	defer delete(ingredients)
	defer delete(ranges)
	return part_one(ingredients, ranges), part_two(ingredients, ranges)
}

@(private = "file")
Range :: struct {
	start: uint,
	end:   uint,
}

@(private = "file")
part_one :: proc(ingredients: [dynamic]uint, ranges: [dynamic]Range) -> uint {
	result: uint
	ingredient_for: for ingredient in ingredients {
		for range in ranges {
			if ingredient >= range.start && ingredient <= range.end {
				result += 1
				continue ingredient_for
			}
		}
	}
	return result
}

@(test)
day_five_part_one_test :: proc(t: ^testing.T) {
	fcontent, err := utils.load_input("five_test")
	if err != nil {
		fmt.printfln("[TD5P1!] error opening input file: %s", err)
		testing.fail(t)
	}
	defer delete(fcontent)
	ingredients, ranges := parse_input(fcontent)
	defer delete(ingredients)
	defer delete(ranges)
	expected: uint = 3
	got := part_one(ingredients, ranges)
	testing.expectf(t, expected == got, "got: %d, expected: %d", got, expected)
}

@(private = "file")
part_two :: proc(ingredients: [dynamic]uint, ranges: [dynamic]Range) -> uint {
	ranges := ranges[:]
	result: uint
	sort.quick_sort_proc(ranges, compare_ranges)
	current_start := ranges[0].start
	current_end := ranges[0].end
	for range in ranges[1:] {
		if range.start <= current_end {
			current_end = max(current_end, range.end)
		} else {
			result += current_end - current_start + 1
			current_start = range.start
			current_end = range.end
		}
	}
	result += current_end - current_start + 1
	return result
}

@(test)
day_five_part_two_test :: proc(t: ^testing.T) {
	fcontent, err := utils.load_input("five_test")
	if err != nil {
		fmt.printfln("[TD5P2!] error opening input file: %s", err)
		testing.fail(t)
	}
	defer delete(fcontent)
	ingredients, ranges := parse_input(fcontent)
	defer delete(ingredients)
	defer delete(ranges)
	expected: uint = 14
	got := part_two(ingredients, ranges)
	testing.expectf(t, expected == got, "got: %d, expected: %d", got, expected)
}

@(private = "file")
compare_ranges :: proc(i, j: Range) -> int {
	if i.start < j.start do return -1
	if i.start > j.start do return 1
	return 0
}

@(private = "file")
parse_input :: proc(input: string) -> ([dynamic]uint, [dynamic]Range) {
	ranges := make([dynamic]Range)
	ingredients := make([dynamic]uint)
	trimmed_input := strings.trim_right(input, "\n")
	finish_ranges: bool
	line_for: for line in strings.split_lines_iterator(&trimmed_input) {
		if line == "" {
			finish_ranges = true
			continue
		}
		for !finish_ranges {
			split_string, err := strings.split(line, "-")
			if err != nil {
				fmt.printfln("[D5!] error splitting %s: %s", line, err)
				break
			}
			defer delete(split_string)
			start, ok := strconv.parse_uint(split_string[0])
			if !ok {
				fmt.printfln("[D5!] error converting %s to uint", split_string[0])
				break
			}
			end: uint
			end, ok = strconv.parse_uint(split_string[1])
			if !ok {
				fmt.printfln("[D5!] error converting %s to uint", split_string[1])
				break
			}
			new_range := Range {
				start = start,
				end   = end,
			}
			_, err = append(&ranges, new_range)
			if err != nil {
				fmt.printfln("[D5!] error appending %v: %s", new_range, err)
				break
			}
			continue line_for
		}
		ingredient, ok := strconv.parse_uint(line)
		if !ok {
			fmt.printfln("[D5!] error converting %s to uint", line)
			break
		}
		_, err := append(&ingredients, ingredient)
	}
	return ingredients, ranges
}
