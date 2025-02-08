package main

import "core:c"

import lb "../../lexbor"

init :: proc() {
	mraw := lb.lexbor_mraw_create()
	status := lb.lexbor_mraw_init(mraw, 1024)

	assert(lb.lexbor_status_t(status) == lb.lexbor_status_t.LXB_STATUS_OK)

	lb.lexbor_mraw_destroy(mraw, true)
}

init_null :: proc() {
	status := lb.lexbor_mraw_init(nil, 1024)

	assert(lb.lexbor_status_t(status) == lb.lexbor_status_t.LXB_STATUS_ERROR_OBJECT_IS_NULL)
}

init_stack :: proc() {
	mraw: lb.lexbor_mraw_t
	status := lb.lexbor_mraw_init(&mraw, 1024)

	assert(lb.lexbor_status_t(status) == lb.lexbor_status_t.LXB_STATUS_OK)

	lb.lexbor_mraw_destroy(&mraw, false)
}

init_args :: proc() {
	mraw: lb.lexbor_mraw_t
	status := lb.lexbor_mraw_init(&mraw, 0)

	assert(lb.lexbor_status_t(status) == lb.lexbor_status_t.LXB_STATUS_ERROR_WRONG_ARGS)

	lb.lexbor_mraw_destroy(&mraw, false)
}

mraw_alloc :: proc() {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := lb.lexbor_mraw_alloc(&mraw, 127)

	assert(data != nil)
	assert(lb.lexbor_mraw_data_size(data) == lb.lexbor_mem_align(127))
	assert(mraw.mem.chunk_length == 1)
	assert(mraw.mem.chunk.length == lb.lexbor_mem_align(127) + lb.lexbor_mraw_meta_size())
	assert(mraw.mem.chunk.size == lb.lexbor_mem_align(1024) + lb.lexbor_mraw_meta_size())
	assert(mraw.cache.tree_length == 0)
	assert(mraw.mem.chunk == mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

mraw_alloc_eq :: proc() {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := lb.lexbor_mraw_alloc(&mraw, 1024)

	assert(data != nil)
	assert(lb.lexbor_mraw_data_size(data) == 1024)
	assert(mraw.mem.chunk_length == 1)
	assert(mraw.mem.chunk.length == 1024 + lb.lexbor_mraw_meta_size())
	assert(mraw.mem.chunk.size == 1024 + lb.lexbor_mraw_meta_size())
	assert(mraw.cache.tree_length == 0)
	assert(mraw.mem.chunk == mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

mraw_alloc_overflow_if_len_0 :: proc() {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := lb.lexbor_mraw_alloc(&mraw, 1025)

	assert(data != nil)
	assert(lb.lexbor_mraw_data_size(data) == lb.lexbor_mem_align(1025))
	assert(mraw.mem.chunk_length == 1)
	assert(mraw.mem.chunk.length == lb.lexbor_mem_align(1025) + lb.lexbor_mraw_meta_size())
	assert(
		mraw.mem.chunk.size ==
		lb.lexbor_mem_align(1025) + lb.lexbor_mem_align(1024) + (2 * lb.lexbor_mraw_meta_size()),
	)
	assert(mraw.cache.tree_length == 0)
	assert(mraw.mem.chunk == mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

mraw_alloc_overflow_if_len_not_0 :: proc() {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := lb.lexbor_mraw_alloc(&mraw, 13)

	assert(data != nil)
	assert(lb.lexbor_mraw_data_size(data) == lb.lexbor_mem_align(13))

	data = lb.lexbor_mraw_alloc(&mraw, 1025)

	assert(data != nil)
	assert(lb.lexbor_mraw_data_size(data) == lb.lexbor_mem_align(1025))
	assert(mraw.mem.chunk_first.length == 1024 + lb.lexbor_mraw_meta_size())
	assert(mraw.mem.chunk_first.size == 1024 + lb.lexbor_mraw_meta_size())
	assert(mraw.mem.chunk_length == 2)
	assert(mraw.mem.chunk.length == lb.lexbor_mem_align(1025) + lb.lexbor_mraw_meta_size())
	assert(
		mraw.mem.chunk.size ==
		lb.lexbor_mem_align(1025) + lb.lexbor_mem_align(1024) + (2 * lb.lexbor_mraw_meta_size()),
	)
	assert(mraw.cache.tree_length == 1)
	assert(
		mraw.cache.root.size ==
		(lb.lexbor_mem_align(1024) + lb.lexbor_mraw_meta_size()) -
			(lb.lexbor_mem_align(13) + lb.lexbor_mraw_meta_size()) -
			lb.lexbor_mraw_meta_size(),
	)
	assert(mraw.mem.chunk != mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

mraw_alloc_if_len_not_0 :: proc() {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := lb.lexbor_mraw_alloc(&mraw, 8)

	assert(data != nil)
	assert(lb.lexbor_mraw_data_size(data) == lb.lexbor_mem_align(8))

	data = lb.lexbor_mraw_alloc(&mraw, 1016 - lb.lexbor_mraw_meta_size())

	assert(data != nil)
	assert(lb.lexbor_mraw_data_size(data) == 1016 - lb.lexbor_mraw_meta_size())
	assert(mraw.mem.chunk_length == 1)
	assert(mraw.mem.chunk.length == 1024 + lb.lexbor_mraw_meta_size())
	assert(mraw.mem.chunk.size == mraw.mem.chunk.length)
	assert(mraw.cache.tree_length == 0)
	assert(mraw.mem.chunk == mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

mraw_realloc :: proc() {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := (^c.uint8_t)(lb.lexbor_mraw_alloc(&mraw, 128))

	assert(data != nil)
	assert(lb.lexbor_mraw_data_size(data) == 128)

	new_data := (^c.uint8_t)(lb.lexbor_mraw_realloc(&mraw, data, 256))

	assert(new_data != nil)
	assert(lb.lexbor_mraw_data_size(data) == 256)
	assert(data == new_data)
	assert(mraw.mem.chunk_length == 1)
	assert(mraw.mem.chunk.length == 256 + lb.lexbor_mraw_meta_size())
	assert(mraw.mem.chunk.size == 1024 + lb.lexbor_mraw_meta_size())
	assert(mraw.cache.tree_length == 0)
	assert(mraw.mem.chunk == mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

mraw_realloc_eq :: proc() {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := (^c.uint8_t)(lb.lexbor_mraw_alloc(&mraw, 128))

	assert(data != nil)
	assert(lb.lexbor_mraw_data_size(data) == 128)

	new_data := (^c.uint8_t)(lb.lexbor_mraw_realloc(&mraw, data, 128))

	assert(new_data != nil)
	assert(lb.lexbor_mraw_data_size(data) == 128)
	assert(data == new_data)
	assert(mraw.mem.chunk_length == 1)
	assert(mraw.mem.chunk.length == 128 + lb.lexbor_mraw_meta_size())
	assert(mraw.mem.chunk.size == 1024 + lb.lexbor_mraw_meta_size())
	assert(mraw.cache.tree_length == 0)
	assert(mraw.mem.chunk == mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

mraw_realloc_tail_0 :: proc() {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := (^c.uint8_t)(lb.lexbor_mraw_alloc(&mraw, 128))

	assert(data != nil)
	assert(lb.lexbor_mraw_data_size(data) == 128)

	new_data := (^c.uint8_t)(lb.lexbor_mraw_realloc(&mraw, data, 0))

	assert(new_data == nil)
	assert(mraw.mem.chunk_length == 1)
	assert(mraw.mem.chunk.length == 0)
	assert(mraw.mem.chunk.size == 1024 + lb.lexbor_mraw_meta_size())
	assert(mraw.cache.tree_length == 0)
	assert(mraw.mem.chunk == mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

mraw_realloc_tail_n :: proc() {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := (^c.uint8_t)(lb.lexbor_mraw_alloc(&mraw, 128))

	assert(data != nil)
	assert(lb.lexbor_mraw_data_size(data) == 128)

	data = (^c.uint8_t)(lb.lexbor_mraw_alloc(&mraw, 128))

	assert(data != nil)
	assert(lb.lexbor_mraw_data_size(data) == 128)

	new_data := (^c.uint8_t)(lb.lexbor_mraw_realloc(&mraw, data, 1024))

	assert(new_data != nil)
	assert(lb.lexbor_mraw_data_size(new_data) == 1024)
	assert(data != new_data)
	assert(mraw.mem.chunk_length == 2)
	assert(mraw.mem.chunk.length == 1024 + lb.lexbor_mraw_meta_size())
	assert(mraw.mem.chunk.size == 1024 + lb.lexbor_mraw_meta_size())
	assert(mraw.cache.tree_length == 1)
	assert(
		mraw.cache.root.size ==
		(1024 + lb.lexbor_mraw_meta_size()) -
			(128 + lb.lexbor_mraw_meta_size()) -
			lb.lexbor_mraw_meta_size(),
	)
	assert(mraw.mem.chunk != mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

mraw_realloc_tail_less :: proc() {

}

// TODO https://github.com/lexbor/lexbor/blob/v2.4.0/test/lexbor/core/mraw.c

main :: proc() {
	init()
	init_stack()
	init_args()
	mraw_alloc()
	mraw_alloc_eq()
	mraw_alloc_overflow_if_len_0()
	mraw_alloc_overflow_if_len_not_0()
	mraw_alloc_if_len_not_0()
	mraw_realloc()
	mraw_realloc_eq()
	mraw_realloc_tail_0()
	mraw_realloc_tail_n()
	mraw_realloc_tail_less()
}
