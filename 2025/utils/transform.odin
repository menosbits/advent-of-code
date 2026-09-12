package utils

str_arr_to_byte_arr :: proc(input: []string) -> [][]u8 {
	output := make([][]u8, len(input))
	for value, row in input {
		output[row] = transmute([]u8)value
	}
	return output
}
