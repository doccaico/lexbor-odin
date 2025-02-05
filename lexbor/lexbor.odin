package lexbor

LEXBOR_SHARED :: #config(LEXBOR_SHARED, false)

when ODIN_OS == .Windows {
	// @(extra_linker_flags="/NODEFAULTLIB:" + ("msvcrt" when RAYLIB_SHARED else "libcmt"))
	foreign import lib {
		"windows/lexbor.dll" when LEXBOR_SHARED else "windows/lexbor.lib"
		// "system:Winmm.lib",
		// "system:Gdi32.lib",
		// "system:User32.lib",
		// "system:Shell32.lib",
	}
}
