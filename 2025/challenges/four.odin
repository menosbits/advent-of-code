package challenges

import "aoc:utils"
import "core:fmt"
import vmem "core:mem/virtual"
import "core:strings"
import "core:testing"

four :: proc() -> (uint, uint) {
	arena: vmem.Arena
	arena_err := vmem.arena_init_growing(&arena)
	if arena_err != nil {
		fmt.eprintfln("[D4!] error initializing arena allocator: %s", arena_err)
		return 0, 0
	}
	arena_allocator := vmem.arena_allocator(&arena)
	defer vmem.arena_destroy(&arena)
	fcontent, err := utils.load_input("four", arena_allocator)
	if err != nil {
		fmt.eprintfln("[D4!] error opening input file: %s", err)
		return 0, 0
	}
	rolls: []string
	rolls, err = strings.split_lines(fcontent, arena_allocator)
	if err != nil {
		fmt.eprintfln("[D4!] error parsing input: %s", err)
		return 0, 0
	}
	return part_one(rolls), part_two(utils.str_arr_to_byte_arr(rolls))
}

@(private = "file")
part_one :: proc(grid: []string) -> uint {
	result: uint = 0
	for row := 0; row < len(grid); row += 1 {
		for col := 0; col < len(grid[row]); col += 1 {
			if grid[row][col] == '.' do continue
			adjacent_rolls := 0
			if col > 0 {
				if grid[row][col - 1] == '@' do adjacent_rolls += 1
				if row > 0 && grid[row - 1][col - 1] == '@' do adjacent_rolls += 1
				if row < len(grid) - 1 && grid[row + 1][col - 1] == '@' do adjacent_rolls += 1
			}
			if col + 1 < len(grid) {
				if grid[row][col + 1] == '@' do adjacent_rolls += 1
				if row > 0 && grid[row - 1][col + 1] == '@' do adjacent_rolls += 1
				if row < len(grid) - 1 && grid[row + 1][col + 1] == '@' do adjacent_rolls += 1
			}
			if row > 0 && grid[row - 1][col] == '@' do adjacent_rolls += 1
			if row + 1 < len(grid) && grid[row + 1][col] == '@' do adjacent_rolls += 1
			if adjacent_rolls < 4 do result += 1
		}
	}
	return result
}

@(test)
day_four_part_one_test :: proc(t: ^testing.T) {
	arena: vmem.Arena
	arena_err := vmem.arena_init_growing(&arena)
	if arena_err != nil {
		fmt.eprintfln("[TD4P1!] error initializing arena allocator: %s", arena_err)
		testing.fail(t)
	}
	arena_allocator := vmem.arena_allocator(&arena)
	defer vmem.arena_destroy(&arena)
	fcontent, err := utils.load_input("four_test", arena_allocator)
	if err != nil {
		fmt.eprintfln("[TD4P1!] error opening input file: %s", err)
		testing.fail(t)
	}
	rolls: []string
	rolls, err = strings.split_lines(fcontent, arena_allocator)
	if err != nil {
		fmt.eprintfln("[TD4P1!] error parsing input: %s", err)
		testing.fail(t)
	}
	expected: uint = 13
	got := part_one(rolls)
	testing.expectf(t, got == expected, "got: %d, expected: %d", got, expected)
}

@(private = "file")
part_two :: proc(grid: [][]u8) -> uint {
	defer delete(grid)
	result: uint = 0
	changed := true
	for changed {
		changed = false
		for row := 0; row < len(grid); row += 1 {
			for col := 0; col < len(grid[row]); col += 1 {
				if grid[row][col] == '.' do continue
				adjacent_rolls := 0
				if col > 0 {
					if grid[row][col - 1] == '@' do adjacent_rolls += 1
					if row > 0 && grid[row - 1][col - 1] == '@' do adjacent_rolls += 1
					if row < len(grid) - 1 && grid[row + 1][col - 1] == '@' do adjacent_rolls += 1
				}
				if col + 1 < len(grid) {
					if grid[row][col + 1] == '@' do adjacent_rolls += 1
					if row > 0 && grid[row - 1][col + 1] == '@' do adjacent_rolls += 1
					if row < len(grid) - 1 && grid[row + 1][col + 1] == '@' do adjacent_rolls += 1
				}
				if row > 0 && grid[row - 1][col] == '@' do adjacent_rolls += 1
				if row + 1 < len(grid) && grid[row + 1][col] == '@' do adjacent_rolls += 1
				if adjacent_rolls < 4 {
					result += 1
					grid[row][col] = '.'
					changed = true
				}
			}
		}
	}
	return result
}

@(test)
day_four_part_two_test :: proc(t: ^testing.T) {
	arena: vmem.Arena
	arena_err := vmem.arena_init_growing(&arena)
	if arena_err != nil {
		fmt.eprintfln("[TD4P2!] error initializing arena allocator: %s", arena_err)
		testing.fail(t)
	}
	arena_allocator := vmem.arena_allocator(&arena)
	defer vmem.arena_destroy(&arena)
	fcontent, err := utils.load_input("four_test", arena_allocator)
	if err != nil {
		fmt.eprintfln("[TD4P2!] error opening input file: %s", err)
		testing.fail(t)
	}
	rolls: []string
	rolls, err = strings.split_lines(fcontent, arena_allocator)
	if err != nil {
		fmt.eprintfln("[TD4P2!] error parsing input: %s", err)
		testing.fail(t)
	}
	expected: uint = 43
	got := part_two(utils.str_arr_to_byte_arr(rolls))
	testing.expectf(t, got == expected, "got: %d, expected: %d", got, expected)
}
