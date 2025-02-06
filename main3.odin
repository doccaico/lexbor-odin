package main

import "core:c"
import "core:fmt"
import "core:os"

import lxb "./lexbor"

main :: proc() {

	html := "<div><p>First</div>"

	document := lxb.html_document_create()
	if (document == nil) {
		fmt.println("document is 'nil'")
		os.exit(1)
	}

	/* Initialization */
	parser = lxb.html_parser_create()
	status = lxb.html_parser_init(parser)

	// status := lxb.html_document_parse(document, cast([^]lxb.lxb_char_t)raw_data(html), len(html))
	status := lxb.html_document_parse(document, raw_data(html), len(html))
	fmt.println("status code:", status)
	if (cast(lxb.lexbor_status_t)status != lxb.lexbor_status_t.LXB_STATUS_OK) {
		fmt.println("parse is failed")
		os.exit(1)
	}
	fmt.printf("document.opt: %#v\n", document.opt)
	fmt.printf("document adress: %p\n", document)
	fmt.printf("document.head adress: %v\n", document.head)
	fmt.printf("document.body adress: %v\n", document.body)
	fmt.printf("document.done adress: %v\n", document.done)
	fmt.printf("document.css_init adress: %v\n", document.css_init)
	fmt.printf("document.ready_state adress: %#v\n", document.ready_state)
	// fmt.printf("document.css: %v\n", document.css)
	fmt.printf("document.css_init: %v\n", document.css_init)
	fmt.printf("document.opt: %v\n", document.opt)

	// fmt.println(document)
	// fmt.printf("%x\n", document.body)

	// tag_name := lxb.dom_element_qualified_name(auto_cast document.body, nil)
	// tag_name := lxb.dom_element_qualified_name(cast(^lxb.lxb_dom_element_t)document.body, nil)
	// tag_name := lxb.dom_element_qualified_name(cast(^lxb.lxb_dom_element_t)document.body, nil)
	// tag_name := lxb.dom_element_qualified_name(lxb.dom_interface_element(document.body), nil)
	// tag_name := lxb.dom_element_qualified_name(cast(^lxb.lxb_dom_element_t)document.body, nil)

	tag_name := lxb.dom_element_qualified_name(cast(^lxb.lxb_dom_element_t)document.body, nil)
	fmt.println("Start.")

	fmt.println(tag_name[0])
	fmt.printf("Element tag name: %s\n", cstring(tag_name))
	// fmt.printf("Element tag name: %s\n", tag_name)

	fmt.println("Finished.")

	lxb.html_document_destroy(document)
}
