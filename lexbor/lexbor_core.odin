package lexbor

import "core:c"
import "core:c/libc"

// lexbor/core/array.h

lexbor_array_t :: struct {
	list:   [^]rawptr,
	size:   c.size_t,
	length: c.size_t,
}

@(default_calling_convention = "c")
foreign lib {
	lexbor_array_create :: proc() -> ^lexbor_array_t ---
	lexbor_array_init :: proc(array: ^lexbor_array_t, size: c.size_t) -> lxb_status_t ---
	lexbor_array_clean :: proc(array: ^lexbor_array_t) ---
	lexbor_array_destroy :: proc(array: ^lexbor_array_t, self_destroy: bool) -> ^lexbor_array_t ---
	lexbor_array_expand :: proc(array: ^lexbor_array_t, up_to: c.size_t) -> ^rawptr ---
	lexbor_array_push :: proc(array: ^lexbor_array_t, value: rawptr) -> lxb_status_t ---
	lexbor_array_pop :: proc(array: ^lexbor_array_t) -> ^rawptr ---
	lexbor_array_insert :: proc(array: ^lexbor_array_t, idx: c.size_t, value: rawptr) -> lxb_status_t ---
	lexbor_array_set :: proc(array: ^lexbor_array_t, idx: c.size_t, value: rawptr) -> lxb_status_t ---
	lexbor_array_delete :: proc(array: ^lexbor_array_t, begin: c.size_t, length: c.size_t) ---
}

@(require_results)
lexbor_array_get :: proc "c" (array: ^lexbor_array_t, idx: c.size_t) -> rawptr {
	if (idx >= array.length) {
		return nil
	}
	return array.list[idx]
}

@(require_results)
lexbor_array_length :: proc "c" (array: ^lexbor_array_t) -> c.size_t {
	return array.length
}

@(require_results)
lexbor_array_size :: proc "c" (array: ^lexbor_array_t) -> c.size_t {
	return array.size
}

@(default_calling_convention = "c")
foreign lib {
	lexbor_array_get_noi :: proc(array: ^lexbor_array_t, idx: c.size_t) -> rawptr ---
	lexbor_array_length_noi :: proc(array: ^lexbor_array_t) -> c.size_t ---
	lexbor_array_size_noi :: proc(array: ^lexbor_array_t) -> c.size_t ---
}

// lexbor/core/array_obj.h

lexbor_array_obj_t :: struct {
	list:        [^]c.uint8_t,
	size:        c.size_t,
	length:      c.size_t,
	struct_size: c.size_t,
}

@(default_calling_convention = "c")
foreign lib {
	lexbor_array_obj_create :: proc() -> ^lexbor_array_obj_t ---
	lexbor_array_obj_init :: proc(array: ^lexbor_array_obj_t, size: c.size_t, struct_size: c.size_t) -> ^lexbor_array_obj_t ---
	lexbor_array_obj_clean :: proc(array: ^lexbor_array_obj_t) ---
	lexbor_array_obj_destroy :: proc(array: ^lexbor_array_obj_t, self_destroy: bool) -> ^lexbor_array_obj_t ---
	lexbor_array_obj_expand :: proc(array: ^lexbor_array_obj_t, up_to: c.size_t) -> ^c.uint8_t ---
	lexbor_array_obj_push :: proc(array: ^lexbor_array_obj_t) -> rawptr ---
	lexbor_array_obj_push_wo_cls :: proc(array: ^lexbor_array_obj_t) -> rawptr ---
	lexbor_array_obj_push_n :: proc(array: ^lexbor_array_obj_t, count: c.size_t) -> rawptr ---
	lexbor_array_obj_pop :: proc(array: ^lexbor_array_obj_t) -> rawptr ---
	lexbor_array_obj_delete :: proc(array: ^lexbor_array_obj_t, begin: c.size_t, length: c.size_t) ---
}

lexbor_array_obj_erase :: proc "c" (array: ^lexbor_array_obj_t) {
	libc.memset(array, 0, size_of(lexbor_array_obj_t))
}

@(require_results)
lexbor_array_obj_get :: proc "c" (array: ^lexbor_array_obj_t, idx: c.size_t) -> rawptr {
	if (idx >= array.length) {
		return nil
	}
	return &array.list[idx * array.struct_size]
}

@(require_results)
lexbor_array_obj_length :: proc "c" (array: ^lexbor_array_obj_t) -> c.size_t {
	return array.length
}

@(require_results)
lexbor_array_obj_size :: proc "c" (array: ^lexbor_array_obj_t) -> c.size_t {
	return array.size
}

@(require_results)
lexbor_array_obj_struct_size :: proc "c" (array: ^lexbor_array_obj_t) -> c.size_t {
	return array.struct_size
}

@(require_results)
lexbor_array_obj_last :: proc "c" (array: ^lexbor_array_obj_t) -> rawptr {
	if (array.length == 0) {
		return nil
	}
	return &array.list[(array.length - 1) * array.struct_size]
}

@(default_calling_convention = "c")
foreign lib {
	lexbor_array_obj_erase_noi :: proc() ---
	lexbor_array_obj_get_noi :: proc(array: ^lexbor_array_obj_t, idx: c.size_t) -> rawptr ---
	lexbor_array_obj_length_noi :: proc(array: ^lexbor_array_obj_t) -> c.size_t ---
	lexbor_array_obj_size_noi :: proc(array: ^lexbor_array_obj_t) -> c.size_t ---
	lexbor_array_obj_struct_size_noi :: proc(array: ^lexbor_array_obj_t) -> c.size_t ---
	lexbor_array_obj_last_noi :: proc(array: ^lexbor_array_obj_t) -> rawptr ---
}

// lexbor/core/avl.h

lexbor_avl_t :: lexbor_avl
lexbor_avl_node_t :: lexbor_avl_node

lexbor_avl_node_f :: #type proc "c" (
	avl: ^lexbor_avl_t,
	root: ^^lexbor_avl_node_t,
	node: ^lexbor_avl_node_t,
	ctx: rawptr,
) -> lxb_status_t

lexbor_avl_node :: struct {
	type:   c.size_t,
	height: c.short,
	value:  rawptr,
	left:   ^lexbor_avl_node_t,
	right:  ^lexbor_avl_node_t,
	parent: ^lexbor_avl_node_t,
}

lexbor_avl :: struct {
	nodes:      ^lexbor_dobject_t,
	last_right: ^lexbor_avl_node_t,
}

@(default_calling_convention = "c")
foreign lib {
	lexbor_avl_create :: proc() -> ^lexbor_avl_t ---
	lexbor_avl_init :: proc(avl: ^lexbor_avl_t, chunk_len: c.size_t, struct_size: c.size_t) -> lxb_status_t ---
	lexbor_avl_clean :: proc(avl: ^lexbor_avl_t) ---
	lexbor_avl_destroy :: proc(avl: ^lexbor_avl_t, self_destroy: bool) -> ^lexbor_avl_t ---
	lexbor_avl_node_make :: proc(avl: ^lexbor_avl_t, type: c.size_t, value: rawptr) -> ^lexbor_avl_node_t ---
	lexbor_avl_node_clean :: proc(avl: ^lexbor_avl_t) ---
	lexbor_avl_node_destroy :: proc(avl: ^lexbor_avl_t, node: ^lexbor_avl_node_t, self_destroy: bool) -> ^lexbor_avl_node_t ---
	lexbor_avl_node_insert :: proc(avl: ^lexbor_avl_t, scope: ^^lexbor_avl_node_t, type: c.size_t, value: rawptr) -> ^lexbor_avl_node_t ---
	lexbor_avl_node_search :: proc(avl: ^lexbor_avl_t, scope: ^^lexbor_avl_node_t, type: c.size_t) -> ^lexbor_avl_node_t ---
	lexbor_avl_node_remove :: proc(avl: ^lexbor_avl_t, scope: ^^lexbor_avl_node_t, type: c.size_t) -> rawptr ---
	lexbor_avl_node_remove_by_node :: proc(avl: ^lexbor_avl_t, root: ^^lexbor_avl_node_t, node: ^lexbor_avl_node_t) ---
	lexbor_avl_node_foreach :: proc(avl: ^lexbor_avl_t, scope: ^^lexbor_avl_node_t, cb: lexbor_avl_node_f, ctx: rawptr) -> lxb_status_t ---
	lexbor_avl_node_foreach_recursion :: proc(avl: ^lexbor_avl_t, scope: ^lexbor_avl_node_t, callback: lexbor_avl_node_f, ctx: rawptr) ---
}

// lexbor/core/base.h

LEXBOR_VERSION_MAJOR :: 1
LEXBOR_VERSION_MINOR :: 8
LEXBOR_VERSION_PATCH :: 0

LEXBOR_VERSION_STRING :: "1.8.0"

lexbor_max :: max
lexbor_min :: min

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

lexbor_action_t :: enum c.int {
	LEXBOR_ACTION_OK   = 0x00,
	LEXBOR_ACTION_STOP = 0x01,
	LEXBOR_ACTION_NEXT = 0x02,
}

lexbor_serialize_cb_f :: #type proc "c" (data: [^]lxb_char_t, ctx: rawptr) -> lxb_status_t

lexbor_serialize_cb_cp_f :: #type proc "c" (
	cps: ^lxb_codepoint_t,
	len: c.size_t,
	ctx: rawptr,
) -> lxb_status_t

lexbor_serialize_ctx_t :: struct {
	cb:    lexbor_serialize_cb_f,
	ctx:   rawptr,
	opt:   c.intptr_t,
	count: c.size_t,
}

// lexbor/core/bst.h

lxb_bst_root :: #force_inline proc "c" (bst: ^lexbor_bst) -> ^lexbor_bst_entry_t {
	return bst.root
}
lxb_bst_root_ref :: #force_inline proc "c" (bst: ^lexbor_bst) -> ^^lexbor_bst_entry_t {
	return &bst.root
}

lexbor_bst_entry_t :: lexbor_bst_entry
lexbor_bst_t :: lexbor_bst

lexbor_bst_entry_f :: #type proc "c" (
	bst: ^lexbor_bst_t,
	entry: lexbor_bst_entry_t,
	ctx: rawptr,
) -> bool

lexbor_bst_entry :: struct {
	value:  rawptr,
	right:  ^lexbor_bst_entry_t,
	left:   ^lexbor_bst_entry_t,
	next:   ^lexbor_bst_entry_t,
	parent: ^lexbor_bst_entry_t,
	size:   c.size_t,
}

lexbor_bst :: struct {
	dobject:     ^lexbor_dobject_t,
	root:        ^lexbor_bst_entry_t,
	tree_length: c.size_t,
}

@(default_calling_convention = "c")
foreign lib {
	lexbor_bst_create :: proc() -> ^lexbor_bst_t ---
	lexbor_bst_init :: proc(bst: ^lexbor_bst_t, size: c.size_t) -> lxb_status_t ---
	lexbor_bst_clean :: proc(bst: ^lexbor_bst_t) ---
	lexbor_bst_destroy :: proc(bst: ^lexbor_bst_t, self_destroy: bool) -> ^lexbor_bst_t ---
	lexbor_bst_entry_make :: proc(bst: ^lexbor_bst_t, size: c.size_t) -> ^lexbor_bst_entry_t ---
	lexbor_bst_insert :: proc(bst: ^lexbor_bst_t, scope: ^^lexbor_bst_entry_t, size: c.size_t, value: rawptr) -> ^lexbor_bst_entry_t ---
	lexbor_bst_insert_not_exists :: proc(bst: ^lexbor_bst_t, scope: ^^lexbor_bst_entry_t, size: c.size_t) -> ^lexbor_bst_entry_t ---
	lexbor_bst_search :: proc(bst: ^lexbor_bst_t, scope: ^lexbor_bst_entry_t, size: c.size_t) -> ^lexbor_bst_entry_t ---
	lexbor_bst_search_close :: proc(bst: ^lexbor_bst_t, scope: ^lexbor_bst_entry_t, size: c.size_t) -> ^lexbor_bst_entry_t ---
	lexbor_bst_remove :: proc(bst: ^lexbor_bst_t, root: ^^lexbor_bst_entry_t, size: c.size_t) -> rawptr ---
	lexbor_bst_remove_close :: proc(bst: ^lexbor_bst_t, root: ^^lexbor_bst_entry_t, size: c.size_t, found_size: ^c.size_t) -> rawptr ---
	lexbor_bst_remove_by_pointer :: proc(bst: ^lexbor_bst_t, entry: ^lexbor_bst_entry_t, root: ^^lexbor_bst_entry_t) -> rawptr ---
	lexbor_bst_serialize :: proc(bst: ^lexbor_bst_t, callback: lexbor_callback_f, ctx: rawptr) ---
	lexbor_bst_serialize_entry :: proc(entry: ^lexbor_bst_entry_t, callback: lexbor_callback_f, ctx: rawptr, tabs: c.size_t) ---
}

// lexbor/core/bst_map.h

lexbor_bst_map_entry_t :: struct {
	str:   lexbor_str_t,
	value: rawptr,
}

lexbor_bst_map_t :: struct {
	bst:     ^lexbor_bst_t,
	mraw:    ^lexbor_mraw_t,
	entries: ^lexbor_dobject_t,
}

@(default_calling_convention = "c")
foreign lib {
	lexbor_bst_map_create :: proc() -> lexbor_bst_map_t ---
	lexbor_bst_map_init :: proc(bst_map: ^lexbor_bst_map_t, size: c.size_t) -> lxb_status_t ---
	lexbor_bst_map_clean :: proc(bst_map: ^lexbor_bst_map_t, size: c.size_t) ---
	lexbor_bst_map_destroy :: proc(bst_map: ^lexbor_bst_map_t, self_destroy: bool) -> ^lexbor_bst_map_t ---
	lexbor_bst_map_search :: proc(bst_map: ^lexbor_bst_map_t, scope: ^lexbor_bst_entry_t, key: [^]lxb_char_t, key_len: c.size_t) -> ^lexbor_bst_map_entry_t ---
	lexbor_bst_map_insert :: proc(bst_map: ^lexbor_bst_map_t, scope: ^^lexbor_bst_entry_t, key: [^]lxb_char_t, key_len: c.size_t, value: rawptr) -> ^lexbor_bst_map_entry_t ---
	lexbor_bst_map_insert_not_exists :: proc(bst_map: ^lexbor_bst_map_t, scope: ^^lexbor_bst_entry_t, key: [^]lxb_char_t, key_len: c.size_t) -> ^lexbor_bst_map_entry_t ---
	lexbor_bst_map_remove :: proc(bst_map: ^lexbor_bst_map_t, scope: ^^lexbor_bst_entry_t, key: [^]lxb_char_t, key_len: c.size_t) -> rawptr ---
}

@(require_results)
lexbor_bst_map_mraw :: proc "c" (bst_map: ^lexbor_bst_map_t) -> ^lexbor_mraw_t {
	return bst_map.mraw
}

@(default_calling_convention = "c")
foreign lib {
	lexbor_bst_map_mraw_noi :: proc(bst_map: ^lexbor_bst_map_t) -> ^lexbor_mraw_t ---
}

// lexbor/core/conv.h

LEXBOR_HASH_SHORT_SIZE :: 16

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

// lexbor/core/types.h

lxb_codepoint_t :: c.uint32_t
lxb_char_t :: c.uchar
lxb_status_t :: c.uint

lexbor_callback_f :: #type proc "c" (
	buffer: [^]lxb_char_t,
	size: c.size_t,
	ctx: rawptr,
) -> lxb_status_t

// Fucntions

@(default_calling_convention = "c")
foreign lib {
}
