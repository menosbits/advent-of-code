package utils

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"

load_input :: proc(challenge: string, allocator := context.allocator) -> (string, os.Error) {
	path := fmt.aprintf("%s/../inputs/%s", filepath.dir(#location().file_path), challenge)
	defer delete(path)
	fcontent, err := os.read_entire_file_from_path(path, allocator, #location())
	if err != nil {
		return "", err
	}
	return strings.trim(string(fcontent), " \n"), nil
}
