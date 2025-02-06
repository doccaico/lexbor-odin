package main

import "core:c"
import "core:fmt"
import "core:os"

import lxb "./lexbor"

main :: proc() {

	// html := `
	// <!DOCTYPE html>
	// <html lang="ja">
	// <head>
	// <meta charset="utf-8" />
	// <title>My Home Page</title>
	// </head>
	// <body>
	// <div>Works fine!</div>
	// </body>
	// </html>  
	// `


	// html := `
	// <!DOCTYPE html>
	// <html lang="ja">
	// <head>
	// <meta charset="utf-8" />
	// <title>My Home Page</title>
	// <style>
	// h1 {
	// 	font-size:24px;
	// 	font-weight: bold;
	// 	color: #ff7800;
	// }
	// </style>
	// </head>
	// <body>
	// <div>Works fine!</div>
	// </body>
	// </html>  
	// `


	html := "<div>Works fine!</div>"
	// html: cstring = "<div>Works fine!</div>"
	// html := "Works fine!<body> "
	// html := "<body><div>Works fine!</div></body> "
	// html := "<!DOCTYPE html>"

	document := lxb.html_document_create()
	if (document == nil) {
		fmt.println("document is 'nil'")
		os.exit(1)
	}

	// fmt.printf("dom_document: %x\n", document.dom_document) // no

	// if (document.dom_document == nil) {
	// 	fmt.println("document.dom_document is 'nil'")
	// 	os.exit(1)
	// }
	// fmt.printf("%x\n", document) // no
	// fmt.printf("%x\n", document.dom_document) // no
	fmt.printf("%v\n", document.iframe_srcdoc) // 0x0
	fmt.printf("%v\n", document.head) // nil
	fmt.printf("%v\n", document.body) // nil
	fmt.printf("%v\n", document.css) // ok
	fmt.printf("%v\n", document.css_init) // false
	fmt.printf("%v\n", document.done) // nil
	fmt.printf("%v\n", document.ready_state) // LXB_HTML_DOCUMENT_READY_STATE_UNDEF
	fmt.printf("%v\n", document.opt) // 0

	// status := lxb.html_document_parse(document, cast([^]lxb.lxb_char_t)raw_data(html), len(html))
	// status := lxb.html_document_parse(document, cast([^]lxb.lxb_char_t)html, len(html))
	status := lxb.html_document_parse(document, raw_data(html), len(html))
	fmt.println("status code:", status)
	if (cast(lxb.lexbor_status_t)status != lxb.lexbor_status_t.LXB_STATUS_OK) {
		fmt.println("parse is failed")
		os.exit(1)
	}
	fmt.printf("document.body adress: %v\n", document.body)

	// tag_name := lxb.dom_element_qualified_name(cast(^lxb.lxb_dom_element_t)document.body, nil)
	//
	// fmt.println("Start.")
	//
	// fmt.println(tag_name[0])
	// fmt.printf("Element tag name: %s\n", cstring(tag_name))
	//
	// // fmt.printf("Element tag name: %s\n", tag_name)
	//
	// fmt.println("Finished.")
	//
	// lxb.html_document_destroy(document)

	// expected result: Element tag name: body
}

// fmt.printf("document.opt: %#v\n", document.opt)
// fmt.printf("document adress: %p\n", document)
// fmt.printf("document.head adress: %v\n", document.head)
// fmt.printf("document.done adress: %v\n", document.done)
// fmt.printf("document.css_init adress: %v\n", document.css_init)
// fmt.printf("document.ready_state adress: %#v\n", document.ready_state)
// // fmt.printf("document.css: %v\n", document.css)
// fmt.printf("document.css_init: %v\n", document.css_init)
// fmt.printf("document.opt: %v\n", document.opt)

// fmt.println(document)
// fmt.printf("%x\n", document.body)

// tag_name := lxb.dom_element_qualified_name(auto_cast document.body, nil)
// tag_name := lxb.dom_element_qualified_name(cast(^lxb.lxb_dom_element_t)document.body, nil)
// tag_name := lxb.dom_element_qualified_name(cast(^lxb.lxb_dom_element_t)document.body, nil)
// tag_name := lxb.dom_element_qualified_name(lxb.dom_interface_element(document.body), nil)
// tag_name := lxb.dom_element_qualified_name(cast(^lxb.lxb_dom_element_t)document.body, nil)
