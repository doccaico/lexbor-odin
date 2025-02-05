package lexbor

// LEXBOR_SHARED :: #config(LEXBOR_SHARED, false)

when ODIN_OS == .Windows {
	// @(extra_linker_flags="/NODEFAULTLIB:" + ("msvcrt" when RAYLIB_SHARED else "libcmt"))
	foreign import lib {
		"windows/lexbor.lib"
		// "system:Winmm.lib",
		// "system:Gdi32.lib",
		// "system:User32.lib",
		// "system:Shell32.lib",
	}
}

// html module

// Define

lxb_html_element :: struct {
	element: lxb_dom_element_t,
	style:   ^lexbor_avl_node_t,
	list:    ^lxb_css_rule_declaration_list_t,
}
lxb_html_element_t :: lxb_html_element

lxb_html_document :: struct {
	dom_document: lxb_dom_document_t,
	iframe_srcdoc: rawptr,
	head: ^lxb_html_head_element_t,
	body: ^lxb_html_body_element_t,
	// todo
	css: lxb_html_document_css_t,
	css_init: bool,
	done: lxb_html_document_done_cb_f,
	ready_state: lxb_html_document_ready_state_t,
	opt: lxb_html_document_opt_t,
}
lxb_html_document_t::lxb_html_document

lxb_html_head_element :: struct {
	element: lxb_html_element_t
}
lxb_html_head_element_t :: lxb_html_head_element

lxb_html_body_element :: struct {
	element: lxb_html_element_t
}
lxb_html_body_element_t :: lxb_html_body_element

// Fucntions

@(default_calling_convention = "c", link_prefix="lxb_")
foreign lib {
html_document_create :: proc() -> ^lxb_html_document_t ---
}
