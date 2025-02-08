#include <lexbor/html/parser.h>
#include <lexbor/dom/interfaces/element.h>

// #include <lexbor/html/interfaces/element.h> // lxb_html_head_element_t
// #include <lexbor/html/interfaces/body_element.h> // lxb_html_head_element_t
// #include <lexbor/html/interface.h> // lxb_html_head_element_t
// #include <lexbor/dom/interfaces/node.h> // lxb_html_head_element_t
// #include <lexbor/dom/interfaces/document.h> // lxb_html_head_element_t

int
main(int argc, const char *argv[])
{
    lxb_status_t status;
    const lxb_char_t *tag_name;
    lxb_html_document_t *document;

    static const lxb_char_t html[] = "<div>Works fine!</div>";
    size_t html_len = sizeof(html) - 1;

    document = lxb_html_document_create();
    if (document == NULL) {
        exit(EXIT_FAILURE);
    }
	printf("lxb_html_document_t: %d\n", sizeof(lxb_html_document_t)); // 368
	printf("lxb_dom_document_t: %d\n", sizeof(lxb_dom_document_t)); // 248
	// printf("%d\n", sizeof(lxb_html_document_css_t)); // 72
	printf("%d\n", sizeof(lxb_dom_node_t)); // 96
	printf("%d\n", sizeof(lxb_dom_document_cmode_t)); // 4
	printf("%d\n", sizeof(lxb_dom_document_dtype_t)); // 4
	printf("%d\n", sizeof(lxb_dom_document_type_t *)); // 8
	printf("%d\n", sizeof(lxb_dom_element_t *)); // 8
	printf("%d\n", sizeof(lxb_dom_interface_create_f)); // 8
	printf("%d\n", sizeof(lxb_dom_interface_clone_f)); // 8
	printf("%d\n", sizeof(lxb_dom_interface_destroy_f)); // 8
	printf("%d\n", sizeof(struct lxb_dom_document_node_cb_t *)); // 8
	printf("%d\n", sizeof(lexbor_mraw_t *)); // 8
	printf("%d\n", sizeof(lexbor_hash_t *)); // 8
	printf("%d\n", sizeof(void *)); // 8
	printf("%d\n", sizeof(bool)); // 1
	printf("%p\n", &(document->dom_document.tags_inherited)); // 1
	printf("%p\n", &(document->dom_document.ns_inherited)); // 1
	printf("%p\n", &(document->dom_document.scripting)); // 1

	// printf("%d\n", sizeof(struct lxb_dom_document_node_cb_t)); // x

    printf("--------------\n");
	printf("%d\n", sizeof(lxb_dom_node_t)); // 1
	printf("%d\n", sizeof(lxb_dom_element_t)); // 1
	printf("%d\n", sizeof(lxb_dom_attr_t)); // 1
	printf("%d\n", sizeof(lxb_dom_event_target_t)); // 1
	// printf("%d\n", sizeof(struct lxb_dom_document_node_cb_t)); // 1
	printf("%d\n", sizeof(lxb_dom_document_type_t)); // 1
	printf("%d\n", sizeof(uintptr_t)); // 1
	printf("%d\n", sizeof(lexbor_mraw_t)); // 1
	printf("%d\n", sizeof(lexbor_hash_t)); // 1
    // printf("%p\n", &document->dom_document);
    // printf("%p\n", &document->dom_document.compat_mode);
    // printf("%d\n", &document->dom_document.node.local_name);
    // printf("%p\n", &document->dom_document.compat_mode);
    // printf("%p\n", &document->dom_document.type);
	// printf("%p\n", &(document->dom_document.node)); // 1
	// printf("%p\n", &(document->dom_document.scripting)); // 1
	// printf("%d\n", sizeof(lxb_dom_event_target_t)); // 1

    printf("--------------\n");
    
 
	// printf("lxb_html_head_element_t: %d\n", sizeof(struct lxb_html_head_element)); // 368
	// printf("lxb_html_head_element_t: %d\n", sizeof(lxb_html_head_element_t)); // 368

	printf("%p\n", document->dom_document); // why ok ?!?!?!?
	// fmt.printf("%v\n", document.iframe_srcdoc) // 0x0
	// fmt.printf("%v\n", document.head) // nil
	// fmt.printf("%v\n", document.body) // nil
	// fmt.printf("%v\n", document.css) // ok
	// fmt.printf("%v\n", document.css_init) // false
	// fmt.printf("%v\n", document.done) // nil
	// printf("%d\n", document->ready_state); // LXB_HTML_DOCUMENT_READY_STATE_UNDEF
	// fmt.printf("%v\n", document.opt) // 0

    printf("document: %p\n", document); // 12345
    printf("body: %p\n", document->body); // 0


    status = lxb_html_document_parse(document, html, html_len);
    if (status != LXB_STATUS_OK) {
        exit(EXIT_FAILURE);
    }

    printf("document: %p\n", document); // 12345
    printf("body: %p\n", document->body); // 98766

    tag_name = lxb_dom_element_qualified_name(lxb_dom_interface_element(document->body), NULL);

    printf("Element tag name: %s\n", tag_name);

    lxb_html_document_destroy(document);

    return EXIT_SUCCESS;
}
