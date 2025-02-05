package lexbor

import "core:c"

// dom module

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

lexbor_mraw_t :: struct {
	mem:       ^lexbor_mem_t,
	cache:     ^lexbor_bst_t,
	ref_count: c.size_t,
}
lexbor_mem_t :: lexbor_mem

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
		long_str:  ^lxb_char_t,
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

// Fucntions

@(default_calling_convention = "c")
foreign lib {
}
