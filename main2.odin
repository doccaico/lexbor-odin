package main

import "core:fmt"
import "core:os"

import lxb "./lexbor"

main :: proc() {

	html :: `
	<!DOCTYPE html>
	<html lang="ja">
	<head>
	<meta charset="utf-8" />
	<title>タイトル</title>
	</head>
	<body>
	</body>
	</html>
	`
	doc := lxb.html_document_create()
	if (doc == nil) {
		fmt.println("document is 'nil'")
		os.exit(1)
	}
	fmt.println("Start.")
	defer fmt.println("Finished.")

	// if (doc.head == nil) {
	// 	fmt.println("head is 'nil'")
	// }
	// fmt.println(doc.dom_document.doctype.name)
	// fmt.println(doc.head.element.element.first_attr.value.length)
	// fmt.println(doc.head.element.element.first_attr.value.length)
	// fmt.println(doc.head.element.element.first_attr.value.length)
	// fmt.println(doc.head.element.element.first_attr.value.length)
	// fmt.println(doc.head.element.element.upper_name)
}
