package main

import "aoc:challenges"
import "core:fmt"

main :: proc() {
	fmt.printfln("\n% 30s\n", "-=[Advent Of Code]=-")
	fmt.printfln("Day 1 :: % 15d :: % 15d", challenges.one())
	fmt.printfln("Day 2 :: % 15d :: % 15d", challenges.two())
	fmt.printfln("Day 3 :: % 15d :: % 15d", challenges.three())
}
