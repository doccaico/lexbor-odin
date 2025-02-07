package lexbor

// tag module

when ODIN_OS == .Windows {
	when LEXBOR_SHARED {
		foreign import lib "windows/lexbor.dll"
	} else {
		foreign import lib "windows/lexbor.lib"
	}
}

import "core:c"

// Define

lxb_tag_id_t :: c.uintptr_t

// Fucntions

@(default_calling_convention = "c")
foreign lib {
	// ClearBackground :: proc(color: Color) ---
}
