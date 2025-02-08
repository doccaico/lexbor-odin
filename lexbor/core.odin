package lexbor

// core module

import "core:c"

// Define

LEXBOR_HASH_SHORT_SIZE :: 16

lxb_char_t :: c.uchar
lxb_status_t :: c.uint

lexbor_str_t :: struct {
	data:   [^]lxb_char_t,
	length: c.size_t,
}

lexbor_mem_chunk :: struct {
	data:   [^]c.uint8_t,
	length: c.size_t,
	size:   c.size_t,
	next:   ^lexbor_mem_chunk_t,
	prev:   ^lexbor_mem_chunk_t,
}
lexbor_mem_chunk_t :: lexbor_mem_chunk

lexbor_mem :: struct {
	chunk:          ^lexbor_mem_chunk_t,
	chunk_first:    ^lexbor_mem_chunk_t,
	chunk_min_size: c.size_t,
	chunk_length:   c.size_t,
}
lexbor_mem_t :: lexbor_mem

lexbor_mraw_t :: struct {
	mem:       ^lexbor_mem_t,
	cache:     ^lexbor_bst_t,
	ref_count: c.size_t,
}

lexbor_array_t :: struct {
	list:   ^rawptr,
	size:   c.size_t,
	length: c.size_t,
}

lexbor_dobject_t :: struct {
	mem:         ^lexbor_mem_t,
	cache:       ^lexbor_array_t,
	allocated:   c.size_t,
	struct_size: c.size_t,
}

lexbor_hash :: struct {
	entries:     ^lexbor_dobject_t,
	mraw:        ^lexbor_mraw_t,
	table:       ^^lexbor_hash_entry_t,
	table_size:  c.size_t,
	struct_size: c.size_t,
}
lexbor_hash_t :: lexbor_hash

lexbor_hash_entry :: struct {
	u:      struct #raw_union {
		long_str:  [^]lxb_char_t,
		short_str: [LEXBOR_HASH_SHORT_SIZE + 1]lxb_char_t,
	},
	length: c.size_t,
	next:   ^lexbor_hash_entry_t,
}
lexbor_hash_entry_t :: lexbor_hash_entry

lexbor_bst :: struct {
	dobject:     ^lexbor_dobject_t,
	root:        ^lexbor_bst_entry_t,
	tree_length: c.size_t,
}
lexbor_bst_t :: lexbor_bst

lexbor_bst_entry :: struct {
	value:  rawptr,
	right:  ^lexbor_bst_entry_t,
	left:   ^lexbor_bst_entry_t,
	next:   ^lexbor_bst_entry_t,
	parent: ^lexbor_bst_entry_t,
	size:   c.size_t,
}
lexbor_bst_entry_t :: lexbor_bst_entry

lexbor_avl_node :: struct {
	type:   c.size_t,
	height: c.short,
	value:  rawptr,
	left:   ^lexbor_avl_node_t,
	right:  ^lexbor_avl_node_t,
	parent: ^lexbor_avl_node_t,
}
lexbor_avl_node_t :: lexbor_avl_node

lexbor_array_obj_t :: struct {
	list:        ^c.uint8_t,
	size:        c.size_t,
	length:      c.size_t,
	struct_size: c.size_t,
}

lexbor_avl :: struct {
	nodes:      ^lexbor_dobject_t,
	last_right: ^lexbor_avl_node_t,
}
lexbor_avl_t :: lexbor_avl

lexbor_status_t :: enum c.int {
	LXB_STATUS_OK = 0x0000,
	LXB_STATUS_ERROR = 0x0001,
	LXB_STATUS_ERROR_MEMORY_ALLOCATION,
	LXB_STATUS_ERROR_OBJECT_IS_NULL,
	LXB_STATUS_ERROR_SMALL_BUFFER,
	LXB_STATUS_ERROR_INCOMPLETE_OBJECT,
	LXB_STATUS_ERROR_NO_FREE_SLOT,
	LXB_STATUS_ERROR_TOO_SMALL_SIZE,
	LXB_STATUS_ERROR_NOT_EXISTS,
	LXB_STATUS_ERROR_WRONG_ARGS,
	LXB_STATUS_ERROR_WRONG_STAGE,
	LXB_STATUS_ERROR_UNEXPECTED_RESULT,
	LXB_STATUS_ERROR_UNEXPECTED_DATA,
	LXB_STATUS_ERROR_OVERFLOW,
	LXB_STATUS_CONTINUE,
	LXB_STATUS_SMALL_BUFFER,
	LXB_STATUS_ABORTED,
	LXB_STATUS_STOPPED,
	LXB_STATUS_NEXT,
	LXB_STATUS_STOP,
	LXB_STATUS_WARNING,
}

// Fucntions

@(default_calling_convention = "c")
foreign lib {
}
