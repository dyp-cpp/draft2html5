function process_to_so(xml_doc, on_completion)
{
	console.log(xml_doc);
}

function getElementsByXpath(context_node, path)
{
	// even if there's only one element, we want to get a "collection"
	var xpath_result = document.evaluate(path, context_node, null, XPathResult.AnyType, null);
	
	var arr = [];p
	for(var match = xpath_result.iterateNext();
	    match;
	    match = xpath_result.iterateNext())
	{
		arr.push(match);
	}
	
	return arr;
}

function has_css_class(element, cls)
{
	// thanks Felix Kling, http://stackoverflow.com/a/5898748
	return (' '+element.className+' ').indexOf(' '+cls+' ') > -1;
}


function at_least(minimum, value)
{
	return value > minimum ? value : minimum;
}

function get_quot_select()
{
	return document.getElementById("quot_select");
}

function for_each(RARange, f)
{
	for(var i = 0; i < RARange.length; ++i)
	{
		f(RARange[i]);
	}
}

function quote_result_t()
{
	this.node = document.getElementById("quote_result");
}
quote_result_t.prototype.show = function()
{
	this.node.style.display = "block";
}
quote_result_t.prototype.hide = function()
{
	this.node.style.display = "none";
}

function quote_window_begin_move(event)
{
	var quote_result_window = document.getElementById("quote_result_window");
	quote_result_window.style.position = "fixed";
	
	var offsetX = quote_result_window.getBoundingClientRect().left - (event.clientX + window.pageXOffset);
	var offsetY = quote_result_window.getBoundingClientRect().top - (event.clientY + window.pageYOffset);
	
	window.onmousemove = function(event)
	{
		quote_result_window.style.left = (offsetX + event.clientX + window.pageXOffset) + "px";
		quote_result_window.style.top = (offsetY + event.clientY + window.pageYOffset) + "px";
	};
	
	window.onmouseup = function(event)
	{
		window.onmousemove = null;
	}
}

var quote_result = null;

window.addEventListener("DOMContentLoaded", function(event) {	// why window, not document?
	quote_result = new quote_result_t();
	document.getElementById("quote_result_window_header").addEventListener("mousedown", quote_window_begin_move);
});


function nearest_ancestor_with_id(start)
{
	var pred = "ancestor-or-self::*[@id][1]"; // XPath
	return getElementsByXpath(start, pred)[0];
}
function nearest_prev_sibling_with_id(start)
{
	start = start.previousSibling;
	while(null != start)
	{
		if(   start.nodeType == Node.ELEMENT_NODE
		   && start.hasAttribute("id"))
		{
			return start;
		}
		start = start.previousSibling;
	}
	return start;
}
function nearest_next_sibling_with_id(start)
{
	start = start.nextSibling;
	while(null != start)
	{
		if(   start.nodeType == Node.ELEMENT_NODE
		   && start.hasAttribute("id"))
		{
			return start;
		}
		start = start.nextSibling;
	}
	return start;
}

function nearest_complete_ancestor(start)
{
	var pred = "ancestor-or-self::*[name()='div' and @class='numbered-paragraph' or name()='section']"; // XPath
	return getElementsByXpath(start, pred)[0];
}

function split_id(id)
{
	var split = {pure_id: null, pure_num: null};
	
	var slash_pos = id.indexOf('/');
	if(-1 == slash_pos)
	{
		split.pure_id = id;
	}else
	{
		split.pure_id = id.substr(0, slash_pos);
		split.pure_num = id.substr(slash_pos+1);
	}
	
	return split;
}

/* returns [{first: node, last: node, common_ancestor: node}]
 */
function get_quote_range_html()
{
	var quote_range_html = [];
	
	var sel = window.getSelection();
	for(var i = 0; i < sel.rangeCount; ++i)
	{
		var range = sel.getRangeAt(i);
		var commonAncestor = range.commonAncestorContainer;
		
		var cur_range = {common_ancestor: commonAncestor};
		if(commonAncestor.nodeType != Node.ELEMENT_NODE)
		{
			// selection is most probably a text node
			cur_range.first = commonAncestor;
			cur_range.last = cur_range.first;
		}else
		{
			/* If the container is a node (not CDATA),
			 * then the first selected node is a child,
			 * described by the offset.
			*/
			function foo_bar(range_container, range_offset)
			{
				if( is_node(range_container) )
				{
					return {node: range_container.children[range_offset], offset: 0};
				}else
				{
					return {node: range_container, offset: range_offset};
				}
			}
			var firstQuotedNode = range.startContainer;
			
			cur_range.first = firstQuotedNode;
			cur_range.last = cur_range.first;
			
			if(commonAncestor != firstQuotedNode)
			{
				var lastQuotedNode = range.endContainer;
				cur_range.last = lastQuotedNode;
			}
		}
		
		quote_range_html.push(cur_range);
	}
	
	return quote_range_html;
}

function get_path_html(outer, inner)
{
	var path = [];
	for(; inner != outer; inner = inner.parentNode)
	{
		path.push(inner);
	}
	path.push(outer);
	path.reverse();
	return path;
}


function array_slice(array, begin_index)
{
	this.array = array;
	this.begin_index = begin_index;
}
	array_slice.prototype.pop_front = function()
	{
		return new array_slice(this.array, this.begin_index+1);
	}
	array_slice.prototype.front = function()
	{
		return this.array[this.begin_index];
	}
	array_slice.prototype.is_empty = function()
	{
		return this.array.length <= this.begin_index;
	}


function get_footnote_id(footnotemark_node)
{
	return footnotemark_node.attributes("href").substr(1);
}
function traverse_footnotemark(n,t,f,c)
{
	var id = get_footnote_id(n);
	n.add_footnode(id);
}


var md_converter = {};

;(function(md_converter) //+ namespace
{

md_converter.impl = {};
md_converter.impl.traversers = {};

;(function(impl) //+ namespace
{

// TODO: name
impl.rel_pos_tracker = function(first_path, last_path)
{
	this.__first = first_path[first_path.length - 1];
	this.__last = last_path[last_path.length - 1];
}
	impl.rel_pos_tracker.OMIT_BEFORE = function() { return 0; }
	impl.rel_pos_tracker.OMIT_AFTER = function()  { return 1; }
	impl.rel_pos_tracker.DONT_OMIT = function()   { return 2; }
	
	impl.rel_pos_tracker.prototype.rel_pos = function(node)
	{
		function contains_flag(value, flag)
		{
			return (value & flag) ? true : false;
		}
		
		// this ... other
		// e.g . this precedes other
		var DOCUMENT_POSITION_FOLLOWING = 2;
		var DOCUMENT_POSITION_PRECEDING = 4;
		var DOCUMENT_POSITION_CONTAINED_BY = 8;
		var DOCUMENT_POSITION_CONTAINS = 16;
		
		var rp_f = node.compareDocumentPosition(this.__first);
		var strictly_before_first = contains_flag(rp_f, DOCUMENT_POSITION_PRECEDING) && !contains_flag(rp_f, DOCUMENT_POSITION_CONTAINS);
		var after_or_includes_first =    contains_flag(rp_f, DOCUMENT_POSITION_FOLLOWING)
		                              || contains_flag(rp_f, DOCUMENT_POSITION_CONTAINS)
		                              || rp_f === 0;
		
		var rp_s = node.compareDocumentPosition(this.__last);
		var before_last =    contains_flag(rp_s, DOCUMENT_POSITION_PRECEDING)
		                  || contains_flag(rp_s, DOCUMENT_POSITION_CONTAINS)
		                  || rp_s === 0;
		var strictly_after_last = contains_flag(rp_s, DOCUMENT_POSITION_FOLLOWING) && !contains_flag(rp_s, DOCUMENT_POSITION_CONTAINS);
		
		var rpt = impl.rel_pos_tracker;
		if(strictly_before_first) return rpt.OMIT_BEFORE();
		if(strictly_after_last  ) return rpt.OMIT_AFTER();
		if( ! (after_or_includes_first && before_last) ) throw "logic flaw";
		return rpt.DONT_OMIT();
	}


/* Class basic_formatter.
 * Immutable.
 */
impl.basic_formatter = function()
{
	this.__state =
		{
			  indent: 0
			, bold: false
			, italic: false
		};
}
	impl.basic_formatter.prototype.indent = function()
	{ return this.__state.indent; }
	
	// TODO: make this private properly
	impl.basic_formatter.prototype.__modified = function(modifications)
	{
		var new_mode = new impl.basic_formatter();
		
		for(i in this.__state)
		{
			if( ! this.__state.hasOwnProperty(i) ) continue;
			
			if(modifications.hasOwnProperty(i))
			{
				new_mode.__state[i] = modifications[i];
			}else
			{
				new_mode.__state[i] = this.__state[i];
			}
		}
		
		return new_mode;
	}
	
	impl.basic_formatter.prototype.print = function(str, converter)
	{
		var indented_newline = "\n";
		for(var i = this.indent(); i > 0; --i)
		{ indented_newline += " "; }
		
		converter.print( str.replace(/\n/g, indented_newline) );
	}

	impl.basic_formatter.prototype.with_modifications = function(converter, modifications, fun)
	{
		var enclosings = 
			{
				  bold:   {before: "<b>", after: "</b>"}
				, italic: {before: "<i>", after: "</i>"}
			};
		
		var self = this;
		function add(which)
		{
			for(key in enclosings)
			{
				if(modifications[key] && ! self.__state[key])
				{
					converter.print(enclosings[key][which]);
				}
			}
		}
		
		add("before");
		fun( this.__modified(modifications) );
		add("after");
	}
	
	impl.basic_formatter.prototype.with_indent = function(converter, i, fun)
	{
		this.with_modifications(converter, {indent: i}, fun);
	}


;(function(traversers) //+ namespace
{

traversers.is_non_normative_block = function(n)
{
	return has_css_class(n, "note") || has_css_class(n, "example");
}

traversers.epsilon = function(n,t,f,c) {}

traversers.default_branch = function(node, traverser, formatter, converter)
{
	for(var i = 0; i < node.childNodes.length; ++i) // manual looping? o.O
	{
		var child = node.childNodes[i];
		converter.traverse(child, traverser, formatter);
	}
}


// TODO: replace by `new default_traverser().omit().indent(4).traverse(n,t,f,c);`
traversers.options = function()
{
	this.__omit = "";
	this.__prefix = "";
	this.__suffix = "";
	this.__indent = 0;
}
	traversers.options.prototype.clone = function()
	{
		var o = new traversers.options();
		o.__omit = this.__omit;
		o.__prefix = this.__prefix;
		o.__suffix = this.__suffix;
		o.__indent = this.__indent;
		return o;
	}	
	
	traversers.options.prototype.omit = function(str)
	{ var c = this.clone(); c.__omit = str; return c; }
	
	traversers.options.prototype.prefix = function(str)
	{ var c = this.clone(); c.__prefix = str; return c; }
	
	traversers.options.prototype.suffix = function(str)
	{ var c = this.clone(); c.__suffix = str; return c; }
	
	traversers.options.prototype.indent = function(str)
	{ var c = this.clone(); c.__indent = str; return c; }
	
	traversers.options.prototype.get_omit = function() { return new String(this.__omit); }
	traversers.options.prototype.get_prefix = function() { return new String(this.__prefix); }
	traversers.options.prototype.get_suffix = function() { return new String(this.__suffix); }

traversers.default_traverse = function(node, traverser, formatter, converter, options)
{
	if(converter.omit())
	{
		formatter.print(node.previousSibling ? "" : options.get_omit(), converter);
	}else
	{
		formatter.print(options.get_prefix(), converter);
		traversers.default_branch(node, traverser, formatter, converter);
		formatter.print(options.get_suffix(), converter);
	}
}


// TODO: traverser interface vs traverser functions interface
traversers.ignore_traverser = function(n,t,f,c)
{
	traversers.default_branch(n,t,f,c);
}
				



traversers.basic_traverser = function()
{}
	
	traversers.basic_traverser.prototype.traverse = function(node, formatter, converter)
	{
		var jt = this.jump_table();
		var traverser = jt [node.nodeName];
		if(traverser === undefined)
		{
			traverser = function(n,t,f,c)
			{
				var op = new traversers.options()
					.omit("...")
					.prefix("<"+n.nodeName+">")
					.suffix("</"+n.nodeName+">")
					.indent(0);
				traversers.default_traverse(n,t,f,c, op);
			};
		}
		traverser(node, this, formatter, converter);
	}

	traversers.basic_traverser.prototype.jump_table = function()
	{
		var bt = this.traversers();
		var obj =
		{
			  "SECTION" : bt.section
			, "HEADER"  : bt.header
			, "DIV"     : bt.div
			, "UL"      : bt.list
			, "OL"      : bt.list
			, "LI"      : bt.li
			, "PRE"     : traversers.default_branch
			, "CODE"    : bt.code
			, "SPAN"    : bt.span
			, "CITE"    : bt.span
			, "VAR"     : bt.span
			, "DFN"     : bt.span
			, "BR"      : bt.br
			, "A"       : bt.a
			, "SUP"     : bt.copy_nonempty
			, "SUB"     : bt.copy_nonempty
			, "#text"   : bt.text
			, "#comment": traversers.epsilon
		};
		return obj;
	};
	
	traversers.basic_traverser.prototype.traversers = function()
	{
		var ret =
		{
			  nnb: function(node, traverser, formatter, converter) // non-normative block
			{
				var op = new traversers.options()
					.prefix(" ")
					.suffix(" ");
				traversers.default_traverse(node, traverser, formatter, converter, op);
			}

			, number: function(n,t,f,c)
			{
				var op = new traversers.options()
					.prefix("<sup>")
					.suffix("</sup>\n");
					;
				traversers.default_traverse(n,t,f,c, op);
			}

			, opt: function(n,t,f,c)
			{
				if( ! c.omit())
				{
					f.print("<sub>", c);
					traversers.default_branch(n,t,f,c);
					f.print("</sub>", c);
				}
			}

			, styled_span: function(n,t,f,c)
			{
				var computed_style = window.getComputedStyle(n);
				
				var i = (computed_style.fontStyle === "italic");
				var b = (computed_style.fontWeight !== "normal");
				
				/* This might not be a good idea.
				 * This logic is to suppress printing format enclosings
				 * if there is no formatted text, e.g. `<i></i>`.
				 * `c.omit()` is only a hint if there will be no text,
				 * there could very well be some.
				 * Due to the indentation, everythings is printed immediately,
				 * instead of buffered/returned
				 * (one could use relative indentation, though).
				 * So, an actual check would require some bookkeeping.
				 * If this becomes a problem, I'd rather vote for restructuring
				 * this to use relative indentation, i.e. for each traverser
				 * function, add the amount of additional indentation to the
				 * string produced for the sub-elements, and return that string.
				*/
				var modifications = {};
				if( ! c.omit() )
				{ modifications = {italic: i, bold: b}; }
				
				f.with_modifications(c, modifications, function(new_f)
				{
					var op = new traversers.options()
						.omit("...")
						;
					
					traversers.default_traverse(n,t,new_f,c, op);
				});
			}

			, span: function(n,t,f,c)
			{
				var is_number = has_css_class(n, "li-number") || has_css_class(n, "par-number");
				if(is_number)
				{
					t.traversers().number(n,t,f,c);
				}else if(has_css_class(n, "opt"))
				{
					t.traversers().opt(n,t,f,c);
				}else
				{
					t.traversers().styled_span(n,t,f,c);
				}
			}

			, code: function(n,t,f,c)
			{
				if( ! c.omit())
				{
					if(has_css_class(n, "inline"))
					{
						f.print(" `"+n.innerText+"` ", c);
					}else
					{
						f.print("\n", c);
						
						var new_f = f.with_indent(c, f.indent()+4, function(new_f){
							new_f.print("\n", c);
							traversers.default_branch(n,t,new_f,c);
						});
						
						f.print("\n\n", c);
					}
				}
			}

			, header: function(n,t,f,c)
			{
				if(c.omit()) { return; }
				
								function make_jt_traverser(jump_table)
				{
					function jt_traverser() {}
					jt_traverser.prototype.traverse = function(n, f, c)
					{
						var traverser = jump_table[n.nodeName];
						if(undefined === traverser)
						{ traverser = jump_table["#default"]; }
						traverser(n, this, f, c);
					}
					
					return new jt_traverser();
				}
				
				var pure_text_traverser = make_jt_traverser(
				{
					  "#text": t.traversers().text
					, "#default": traversers.ignore_traverser
				});
				
				var level = parseInt(n.firstElementChild.nodeName.substr(1), 10);
				for(var i = 0; i < level; ++i)
				{
					f.print("#", c);
				}
				
				traversers.default_branch(n, pure_text_traverser, f,c);
				
				f.print("\n\n", c);
			}

			, section: function(n,t,f,c)
			{
				var op = new traversers.options()
					.omit("[...section]")
					.suffix("\n\n")
					;
				traversers.default_traverse(n,t,f,c, op);
			}

			, pnum: function(n,t,f,c)
			{
				var op = new traversers.options()
					.omit("[...par]")
					.suffix("\n\n")
					;
				traversers.default_traverse(n,t,f,c, op);
			}

			, div: function(n,t,f,c)
			{
				if(traversers.is_non_normative_block(n))
				{
					t.traversers().nnb(n,t,f,c);
				}else
				{
					var id_jt =
					{
						  "numbered-paragraph": t.traversers().pnum
						, "explanation": traversers.ignore_traverser
					};
					var className = n.className;
					var traverser = id_jt[n.className];
					if(traverser === undefined)
					{
						traverser = function(n,t,f,c)
						{
							var op = new traversers.options()
								.omit("[...div]")
								.prefix("<"+n.nodeName+">")
								.suffix("</"+n.nodeName+">");
								;
							traversers.default_traverse(n,t,f,c, op);
						}
					}
					traverser(n,t,f,c);
				}
			}

			, copy_nonempty: function(n,t,f,c)
			{
				var op = new traversers.options()
					.prefix("<"+n.nodeName+">")
					.suffix("</"+n.nodeName+">")
					;
				traversers.default_traverse(n,t,f,c, op);
			}

			, list: function(n,t,f,c)
			{
				if(c.omit())
				{
					f.print("\n\n[...ul]\n\n", c);
				}else
				{
					f.print("\n", c);
					
					var new_f = f.with_indent(c, f.indent()+2, function(new_f){
						traversers.default_branch(n,t,new_f,c);
					});
					
					f.print("\n", c);
				}
			}
			, li: function(n,t,f,c)
			{
				var im = "?";
				if(n.parentNode.nodeName === "UL")
				{ im = "-"; }
				else if(n.parentNode.nodeName === "OL")
				{ im = "1."; }
				
				if(c.omit())
				{
					f.print("", c);
				}else
				{
					f.print("\n"+im+" ", c);
					traversers.default_branch(n,t,f,c);
					f.print("\n", c);
				}
			}

			, text: function(n,t,f,c)
			{
				if(/^\s*$/.test(n.data))
				{ f.print("", c); }
				else if(c.omit())
				{ f.print("[...]", c); }
				else
				{ f.print(n.data, c); }
			}

			, br: function(n,t,f,c)
			{
				if( ! c.omit()) { f.print("\n", c); }
			}

			, a: function(n,t,f,c)
			{
				if(has_css_class(n, "footnoteMark"))
				{
					t.traversers().footnote(n,t,f,c);
				}else
				{
					traversers.default_branch(n,t,f,c);
				}
			}

			, footnote: function(n,t,f,c)
			{
				var op = new traversers.options()
					.prefix("<sup>(\\*")
					.suffix(")</sup>")
					;
				traversers.default_traverse(n,t,f,c, op);
			}
		};
		return ret;
	}//- traversers.basic_traversers.traversers()

//- traversers.basic_traversers


})(md_converter.impl.traversers = md_converter.impl.traversers || {}); //- namespace

})(md_converter.impl = md_converter.impl || {}); //- namespace


/* HTML->MD converter
 * Given a first node, last node and their common ancestor,
 * converts the HTML fragment to MD using a block_traverser.
 */
// TODO: common_ancestor is redundant with first[0]
md_converter.convert = function(first, last, common_ancestor)
{
	var text = "";
	var footnote_text = "";
	
	function traverser_interface()
	{
		var first_path = get_path_html(common_ancestor, first);
		var last_path = get_path_html(common_ancestor, last);
		
		var rpt = md_converter.impl.rel_pos_tracker;
		this.__rpt = new rpt(first_path, last_path);
		
		this.__omit = rpt.OMIT_BEFORE();
	}
		traverser_interface.prototype.print = function(str)
		{ text += str; }
		
		traverser_interface.prototype.add_footnote = function(node)
		{
			// needs to use STORED FIXED traverser & formatter
			
			var single_footnote_text = "";
			
			function footnote_ti() {}
			footnote_ti.prototype.print() = function(str) { single_footnote_text += str; }
			footnote_ti.prototype.add_footnote = function() { alert("footnote in footnote"); }
			footnote_ti.prototype.omit = function() { return false; }
			footnote_ti.prototype.traverse = function(node, traverser, formatter)
			{ traverser.traverse(node, formatter, this); }
			
			this.__footnote_traverser.traverse(node, this.__footnote_formatter, new footnote_ti());
		}
		
		traverser_interface.prototype.omit = function()
		{
			var rpt = md_converter.impl.rel_pos_tracker;
			return (    this.__omit === rpt.OMIT_BEFORE()
			         || this.__omit === rpt.OMIT_AFTER() )
		}
		
		traverser_interface.prototype.traverse = function(node, traverser, formatter)
		{
			this.__omit = this.__rpt.rel_pos(node);
			traverser.traverse(node, formatter, this);
		}
	
	var ti = new traverser_interface();
	ti.traverse(common_ancestor, new md_converter.impl.traversers.basic_traverser(),
	            new md_converter.impl.basic_formatter());
	
	return text;
}


})(md_converter = md_converter || {}); //- namespace


function convert_to_md(first_node, last_node, common_ancestor)
{
	var c = new md_converter.converter(first_node, last_node);
	c.convert();
	return c.text();
}


function oqbc(sender)
{
	alert("TODO: special characters (single quote, asterisk) in code; selection; round indent to next multiple of 4 for code blocks, support for footnotes, omissing strings [...] for text nodes with intermediary formatting");
	var quote_result_text = document.getElementById("quote_result_text");
	quote_result_text.textContent = "";
	
	var quote_range_html = get_quote_range_html();
	
	var quote_text = "";
	quote_range_html.forEach(function(e) {
		quote_text += md_converter.convert(e.first, e.last, e.common_ancestor);
	});
	
	quote_result_text.textContent = quote_text;
	//quote_result_text.textContent += "long intro about the draft and stuff, ["+split_id(ids[0]).pure_id+"]\n\n";
	
	quote_result.show();
}

function on_quote_exit(sender)
{
	quote_result.hide();
}
