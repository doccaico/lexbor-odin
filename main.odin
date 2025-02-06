package main

import "core:c"
import "core:fmt"
import "core:os"

import lxb "./lexbor"

main :: proc() {

	html := `
	<!DOCTYPE html>
	<html lang="ja">
	<head>
	<meta charset="utf-8" />
	<title>My Home Page</title>
	</head>
	<body>
	<div>Works fine!</div>
	</body>
	</html>  
	`


	// html := "<div>Works fine!</div> "
	// html := "<body><div>Works fine!</div></body> "

	document := lxb.html_document_create()
	if (document == nil) {
		fmt.println("document is 'nil'")
		os.exit(1)
	}
	// fmt.printf(document.dom_document)
	// fmt.println(raw_data(html)[1])
	// fmt.println("あいうえお")
	// fmt.println(document.head)

	// status := lxb.html_document_parse(document, ([^]u8)(html[:]), len(html))
	status := lxb.html_document_parse(document, raw_data(html), len(html) - 1)
	if (cast(lxb.lexbor_status_t)status != lxb.lexbor_status_t.LXB_STATUS_OK) {
		fmt.println("parse is failed")
		os.exit(1)
	}
	fmt.println("status code:", status)
	fmt.printf("document adress: %p\n", document)
	fmt.printf("document.head adress: %v\n", document.head)
	fmt.printf("document.body adress: %v\n", document.body)
	fmt.printf("document.done adress: %v\n", document.done)
	fmt.printf("document.ready_state adress: %#v\n", document.ready_state)
	fmt.printf("document.ready_state adress: %#v\n", document.opt)

	// fmt.println(document)
	// fmt.printf("%x\n", document.body)

	tag_name := lxb.dom_element_qualified_name(cast(^lxb.lxb_dom_element_t)document.body, nil)
	// tag_name := lxb.dom_element_qualified_name(cast(^lxb.lxb_dom_element_t)document.body, nil)

	// tag_name := lxb.dom_element_qualified_name(lxb.dom_interface_element(document.body), nil)
	// tag_name := lxb.dom_element_qualified_name(cast(^lxb.lxb_dom_element_t)document.body, nil)

	fmt.println("Start.")

	fmt.println(tag_name[0])
	fmt.println("punk")
	fmt.printf("Element tag name: %s\n", tag_name)

	fmt.println("Finished.")

	lxb.html_document_destroy(document)
}
