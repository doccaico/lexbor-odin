package main

import "core:c"
import "core:fmt"

// Direct :: struct {
//   a, b: int,
// }
//
// Addin :: struct {
// 	a:      int,
// 	string: int,
// 	// context: int
// }
// Combined :: struct {
//   a: int,
//   using _: Addin,
//   d: u8,
// }

main :: proc() {
	// string_ := "hi"
	// a: string = "PUNK"
	// // a: string = "Hi"
	// fmt.println(string_)
	// fmt.println(a)
	// s := Addin{}
	// fmt.println(s.context)
	fmt.println(max(c.long))
	fmt.println(max(1, 222, 3))

}
