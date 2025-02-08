package main

import "core:fmt"
import "core:os"

import lxb "./lexbor"

main :: proc() {

	html := "<div>Works fine!</div>"

	document := lxb.html_document_create()
	if (document == nil) {
		os.exit(1)
	}

	status := lxb.html_document_parse(document, raw_data(html), len(html))
	if (cast(lxb.lexbor_status_t)status != lxb.lexbor_status_t.LXB_STATUS_OK) {
		os.exit(1)
	}

	tag_name := lxb.dom_element_qualified_name(lxb.dom_interface_element(document.body), nil)

	fmt.printf("Element tag name: %s\n", tag_name)

	lxb.html_document_destroy(document)
}
