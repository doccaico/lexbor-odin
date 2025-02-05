package lexbor

import "core:c"

// css module

// Define
lxb_css_memory_t :: struct {
	objs:      ^lexbor_dobject_t,
	mraw:      ^lexbor_mraw_t,
	tee:       ^lexbor_mraw_t,
	ref_count: c.size_t,
}

lxb_css_rule_type_t :: enum c.int {
	LXB_CSS_RULE_UNDEF = 0,
	LXB_CSS_RULE_STYLESHEET,
	LXB_CSS_RULE_LIST,
	LXB_CSS_RULE_AT_RULE,
	LXB_CSS_RULE_STYLE,
	LXB_CSS_RULE_BAD_STYLE,
	LXB_CSS_RULE_DECLARATION_LIST,
	LXB_CSS_RULE_DECLARATION,
}

lxb_css_rule :: struct {
	type:      lxb_css_rule_type_t,
	next:      ^lxb_css_rule_t,
	prev:      ^lxb_css_rule_t,
	parent:    ^lxb_css_rule_t,
	begin:     ^lxb_char_t,
	end:       ^lxb_char_t,
	memory:    ^lxb_css_memory_t,
	ref_count: c.size_t,
}
lxb_css_rule_t :: lxb_css_rule

lxb_css_rule_declaration_list :: struct {
	rule:  lxb_css_rule_t,
	first: ^lxb_css_rule_t,
	last:  ^lxb_css_rule_t,
	count: c.size_t,
}
lxb_css_rule_declaration_list_t :: lxb_css_rule_declaration_list

lxb_html_document_css_t :: struct {
	memory: ^lxb_css_memory_t,
    css_selectors: ^lxb_css_selectors_t,
	// todo
    lxb_css_parser_t    *parser;
    lxb_selectors_t     *selectors;

    lexbor_avl_t        *styles;
    lexbor_array_t      *stylesheets;
    lexbor_dobject_t    *weak;

    lexbor_hash_t       *customs;
    uintptr_t           customs_id;
}

lxb_css_selectors::struct{
	list: ^lxb_css_selector_list_t,
    list_last: ^lxb_css_selector_list_t,
    parent: ^lxb_css_selector_t,
	combinator: lxb_css_selector_combinator_t ,
	comb_default: lxb_css_selector_combinator_t ,
	error: c.uintptr_t ,
	status:bool,
	err_in_function:bool,
	failed:bool,
}
lxb_css_selectors_t :: lxb_css_selectors

lxb_css_selector_specificity_t :: c.uint32_t

lxb_css_selector_list :: struct {
	first: ^lxb_css_selector_t,
    last: ^lxb_css_selector_t,
    parent: ^lxb_css_selector_t,
    next: ^lxb_css_selector_list_t  , 
	prev: ^lxb_css_selector_list_t  ,  
    memory: ^lxb_css_memory_t               ,
    specificity: lxb_css_selector_specificity_t,
}
lxb_css_selector_list_t :: lxb_css_selector_list

lxb_css_selector :: struct {
	type: lxb_css_selector_type_t ,
    combinator: lxb_css_selector_combinator_t,
    name: lexbor_str_t,
	ns: lexbor_str_t  ,
	u:      struct #raw_union {
		attribute: lxb_css_selector_attribute_t,
        pseudo: lxb_css_selector_pseudo_t,
	},
	next: ^lxb_css_selector_t,
	prev: ^lxb_css_selector_t,
    list: ^lxb_css_selector_list_t,
}
lxb_css_selector_t :: lxb_css_selector

lxb_css_selector_type_t :: enum c.int {
    LXB_CSS_SELECTOR_TYPE__UNDEF = 0x00,
    LXB_CSS_SELECTOR_TYPE_ANY,
    LXB_CSS_SELECTOR_TYPE_ELEMENT,                 
    LXB_CSS_SELECTOR_TYPE_ID,                      
    LXB_CSS_SELECTOR_TYPE_CLASS,                   
    LXB_CSS_SELECTOR_TYPE_ATTRIBUTE,               
    LXB_CSS_SELECTOR_TYPE_PSEUDO_CLASS,            
    LXB_CSS_SELECTOR_TYPE_PSEUDO_CLASS_FUNCTION,   
    LXB_CSS_SELECTOR_TYPE_PSEUDO_ELEMENT,          
    LXB_CSS_SELECTOR_TYPE_PSEUDO_ELEMENT_FUNCTION, 
    LXB_CSS_SELECTOR_TYPE__LAST_ENTRY
}

lxb_css_selector_combinator_t :: enum c.int {
    LXB_CSS_SELECTOR_COMBINATOR_DESCENDANT = 0x00,
    LXB_CSS_SELECTOR_COMBINATOR_CLOSE,            
    LXB_CSS_SELECTOR_COMBINATOR_CHILD,            
    LXB_CSS_SELECTOR_COMBINATOR_SIBLING,          
    LXB_CSS_SELECTOR_COMBINATOR_FOLLOWING,        
    LXB_CSS_SELECTOR_COMBINATOR_CELL,             
    LXB_CSS_SELECTOR_COMBINATOR__LAST_ENTRY
}

lxb_css_selector_attribute_t :: struct {
	match: lxb_css_selector_match_t,
    modifier: lxb_css_selector_modifier_t ,
    value: lexbor_str_t,
}

lxb_css_selector_match_t :: enum c.int {
    LXB_CSS_SELECTOR_MATCH_EQUAL = 0x00,  
    LXB_CSS_SELECTOR_MATCH_INCLUDE,       
    LXB_CSS_SELECTOR_MATCH_DASH,          
    LXB_CSS_SELECTOR_MATCH_PREFIX,        
    LXB_CSS_SELECTOR_MATCH_SUFFIX,        
    LXB_CSS_SELECTOR_MATCH_SUBSTRING,     
    LXB_CSS_SELECTOR_MATCH__LAST_ENTRY
}

lxb_css_selector_modifier_t :: enum c.int {
    LXB_CSS_SELECTOR_MODIFIER_UNSET = 0x00,
    LXB_CSS_SELECTOR_MODIFIER_I,
    LXB_CSS_SELECTOR_MODIFIER_S,
    LXB_CSS_SELECTOR_MODIFIER__LAST_ENTRY
}

lxb_css_selector_pseudo_t :: struct{
	type: c.uint,
	data: rawptr,
}

// Fucntions

@(default_calling_convention = "c")
foreign lib {
}
