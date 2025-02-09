package test_core_mraw

import "core:c"
import "core:testing"

import lb "../../lexbor"

// https://github.com/lexbor/lexbor/blob/v2.4.0/test/lexbor/core/mraw.c

@(test)
init :: proc(t: ^testing.T) {
	mraw := lb.lexbor_mraw_create()
	status := lb.lexbor_mraw_init(mraw, 1024)

	testing.expect_value(t, lb.lexbor_status_t(status), lb.lexbor_status_t.LXB_STATUS_OK)

	lb.lexbor_mraw_destroy(mraw, true)
}

@(test)
init_null :: proc(t: ^testing.T) {
	status := lb.lexbor_mraw_init(nil, 1024)

	testing.expect_value(
		t,
		lb.lexbor_status_t(status),
		lb.lexbor_status_t.LXB_STATUS_ERROR_OBJECT_IS_NULL,
	)
}

@(test)
init_stack :: proc(t: ^testing.T) {
	mraw: lb.lexbor_mraw_t
	status := lb.lexbor_mraw_init(&mraw, 1024)

	testing.expect_value(t, lb.lexbor_status_t(status), lb.lexbor_status_t.LXB_STATUS_OK)

	lb.lexbor_mraw_destroy(&mraw, false)
}

@(test)
init_args :: proc(t: ^testing.T) {
	mraw: lb.lexbor_mraw_t
	status := lb.lexbor_mraw_init(&mraw, 0)

	testing.expect_value(
		t,
		lb.lexbor_status_t(status),
		lb.lexbor_status_t.LXB_STATUS_ERROR_WRONG_ARGS,
	)

	lb.lexbor_mraw_destroy(&mraw, false)
}

@(test)
mraw_alloc :: proc(t: ^testing.T) {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := lb.lexbor_mraw_alloc(&mraw, 127)

	testing.expect(t, data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), lb.lexbor_mem_align(127))
	testing.expect_value(t, mraw.mem.chunk_length, 1)
	testing.expect_value(
		t,
		mraw.mem.chunk.length,
		lb.lexbor_mem_align(127) + lb.lexbor_mraw_meta_size(),
	)
	testing.expect_value(
		t,
		mraw.mem.chunk.size,
		lb.lexbor_mem_align(1024) + lb.lexbor_mraw_meta_size(),
	)
	testing.expect_value(t, mraw.cache.tree_length, 0)
	testing.expect_value(t, mraw.mem.chunk, mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

@(test)
mraw_alloc_eq :: proc(t: ^testing.T) {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := lb.lexbor_mraw_alloc(&mraw, 1024)

	testing.expect(t, data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), 1024)
	testing.expect_value(t, mraw.mem.chunk_length, 1)
	testing.expect_value(t, mraw.mem.chunk.length, 1024 + lb.lexbor_mraw_meta_size())
	testing.expect_value(t, mraw.mem.chunk.size, 1024 + lb.lexbor_mraw_meta_size())
	testing.expect_value(t, mraw.cache.tree_length, 0)
	testing.expect_value(t, mraw.mem.chunk, mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

@(test)
mraw_alloc_overflow_if_len_0 :: proc(t: ^testing.T) {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := lb.lexbor_mraw_alloc(&mraw, 1025)

	testing.expect(t, data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), lb.lexbor_mem_align(1025))
	testing.expect_value(t, mraw.mem.chunk_length, 1)
	testing.expect_value(
		t,
		mraw.mem.chunk.length,
		lb.lexbor_mem_align(1025) + lb.lexbor_mraw_meta_size(),
	)
	testing.expect_value(
		t,
		mraw.mem.chunk.size,
		lb.lexbor_mem_align(1025) + lb.lexbor_mem_align(1024) + (2 * lb.lexbor_mraw_meta_size()),
	)
	testing.expect_value(t, mraw.cache.tree_length, 0)
	testing.expect_value(t, mraw.mem.chunk, mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

@(test)
mraw_alloc_overflow_if_len_not_0 :: proc(t: ^testing.T) {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := lb.lexbor_mraw_alloc(&mraw, 13)

	testing.expect(t, data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), lb.lexbor_mem_align(13))

	data = lb.lexbor_mraw_alloc(&mraw, 1025)

	testing.expect(t, data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), lb.lexbor_mem_align(1025))
	testing.expect_value(t, mraw.mem.chunk_first.length, 1024 + lb.lexbor_mraw_meta_size())
	testing.expect_value(t, mraw.mem.chunk_first.size, 1024 + lb.lexbor_mraw_meta_size())
	testing.expect_value(t, mraw.mem.chunk_length, 2)
	testing.expect_value(
		t,
		mraw.mem.chunk.length,
		lb.lexbor_mem_align(1025) + lb.lexbor_mraw_meta_size(),
	)
	testing.expect_value(
		t,
		mraw.mem.chunk.size,
		lb.lexbor_mem_align(1025) + lb.lexbor_mem_align(1024) + (2 * lb.lexbor_mraw_meta_size()),
	)
	testing.expect_value(t, mraw.cache.tree_length, 1)
	testing.expect_value(
		t,
		mraw.cache.root.size,
		(lb.lexbor_mem_align(1024) + lb.lexbor_mraw_meta_size()) -
		(lb.lexbor_mem_align(13) + lb.lexbor_mraw_meta_size()) -
		lb.lexbor_mraw_meta_size(),
	)
	testing.expect(t, mraw.mem.chunk != mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

@(test)
mraw_alloc_if_len_not_0 :: proc(t: ^testing.T) {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := lb.lexbor_mraw_alloc(&mraw, 8)

	testing.expect(t, data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), lb.lexbor_mem_align(8))

	data = lb.lexbor_mraw_alloc(&mraw, 1016 - lb.lexbor_mraw_meta_size())

	testing.expect(t, data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), 1016 - lb.lexbor_mraw_meta_size())
	testing.expect_value(t, mraw.mem.chunk_length, 1)
	testing.expect_value(t, mraw.mem.chunk.length, 1024 + lb.lexbor_mraw_meta_size())
	testing.expect_value(t, mraw.mem.chunk.size, mraw.mem.chunk.length)
	testing.expect_value(t, mraw.cache.tree_length, 0)
	testing.expect_value(t, mraw.mem.chunk, mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

@(test)
mraw_realloc :: proc(t: ^testing.T) {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := (^c.uint8_t)(lb.lexbor_mraw_alloc(&mraw, 128))

	testing.expect(t, data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), 128)

	new_data := (^c.uint8_t)(lb.lexbor_mraw_realloc(&mraw, data, 256))

	testing.expect(t, new_data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), 256)
	testing.expect_value(t, data, new_data)
	testing.expect_value(t, mraw.mem.chunk_length, 1)
	testing.expect_value(t, mraw.mem.chunk.length, 256 + lb.lexbor_mraw_meta_size())
	testing.expect_value(t, mraw.mem.chunk.size, 1024 + lb.lexbor_mraw_meta_size())
	testing.expect_value(t, mraw.cache.tree_length, 0)
	testing.expect_value(t, mraw.mem.chunk, mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

@(test)
mraw_realloc_eq :: proc(t: ^testing.T) {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := (^c.uint8_t)(lb.lexbor_mraw_alloc(&mraw, 128))

	testing.expect(t, data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), 128)

	new_data := (^c.uint8_t)(lb.lexbor_mraw_realloc(&mraw, data, 128))

	testing.expect(t, new_data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), 128)
	testing.expect_value(t, data, new_data)
	testing.expect_value(t, mraw.mem.chunk_length, 1)
	testing.expect_value(t, mraw.mem.chunk.length, 128 + lb.lexbor_mraw_meta_size())
	testing.expect_value(t, mraw.mem.chunk.size, 1024 + lb.lexbor_mraw_meta_size())
	testing.expect_value(t, mraw.cache.tree_length, 0)
	testing.expect_value(t, mraw.mem.chunk, mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

@(test)
mraw_realloc_tail_0 :: proc(t: ^testing.T) {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := (^c.uint8_t)(lb.lexbor_mraw_alloc(&mraw, 128))

	testing.expect(t, data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), 128)

	new_data := (^c.uint8_t)(lb.lexbor_mraw_realloc(&mraw, data, 0))

	testing.expect(t, new_data == nil)
	testing.expect_value(t, mraw.mem.chunk_length, 1)
	testing.expect_value(t, mraw.mem.chunk.length, 0)
	testing.expect_value(t, mraw.mem.chunk.size, 1024 + lb.lexbor_mraw_meta_size())
	testing.expect_value(t, mraw.cache.tree_length, 0)
	testing.expect_value(t, mraw.mem.chunk, mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

@(test)
mraw_realloc_tail_n :: proc(t: ^testing.T) {
	mraw: lb.lexbor_mraw_t
	lb.lexbor_mraw_init(&mraw, 1024)
	data := (^c.uint8_t)(lb.lexbor_mraw_alloc(&mraw, 128))

	testing.expect(t, data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), 128)

	data = (^c.uint8_t)(lb.lexbor_mraw_alloc(&mraw, 128))

	testing.expect(t, data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(data), 128)

	new_data := (^c.uint8_t)(lb.lexbor_mraw_realloc(&mraw, data, 1024))

	testing.expect(t, new_data != nil)
	testing.expect_value(t, lb.lexbor_mraw_data_size(new_data), 1024)
	testing.expect(t, data != new_data)
	testing.expect_value(t, mraw.mem.chunk_length, 2)
	testing.expect_value(t, mraw.mem.chunk.length, 1024 + lb.lexbor_mraw_meta_size())
	testing.expect_value(t, mraw.mem.chunk.size, 1024 + lb.lexbor_mraw_meta_size())
	testing.expect_value(t, mraw.cache.tree_length, 1)
	testing.expect_value(
		t,
		mraw.cache.root.size,
		(1024 + lb.lexbor_mraw_meta_size()) -
		(128 + lb.lexbor_mraw_meta_size()) -
		lb.lexbor_mraw_meta_size(),
	)
	testing.expect(t, mraw.mem.chunk != mraw.mem.chunk_first)

	lb.lexbor_mraw_destroy(&mraw, false)
}

@(test)
mraw_realloc_tail_less :: proc(t: ^testing.T) {

}
