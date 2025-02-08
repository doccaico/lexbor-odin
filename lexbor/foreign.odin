package lexbor

LEXBOR_SHARED :: #config(LEXBOR_SHARED, false)

when ODIN_OS == .Windows {
	when LEXBOR_SHARED {
		foreign import lib "windows/lexbor.dll"
	} else {
		foreign import lib "windows/lexbor.lib"
	}
}
