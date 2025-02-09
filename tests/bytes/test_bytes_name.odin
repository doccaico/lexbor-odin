package test_bytes_name

// import "core:bytes"
// import "core:slice"
import "core:testing"

@(test)
test_number1 :: proc(t: ^testing.T) {
	a := "joe"
	b := "joe"

	testing.expect_value(t, a, b)
}

@(test)
test_number2 :: proc(t: ^testing.T) {
	a := "joe"
	b := "jonny"

	testing.expect(t, a == b)
	// testing.expect_value(t, a, b)
}

@(test)
test_number3 :: proc(t: ^testing.T) {
	a := "joe"
	b := "jonny"

	testing.expect(t, a == b)
	// testing.expect_value(t, a, b)
}
