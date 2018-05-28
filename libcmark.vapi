/*
 * Copyright (c) 2018 Fabio Comuni <fabrix.xm@gmail.com>
 *
 * This library is released under BSD2 license
 *
 * https://github.com/commonmark/cmark
 */

[CCode (cprefix = "cmark_", cheader_filename = "cmark.h")]
namespace CMark {

    /**
     * Options
     *
     * TODO: separate rendering and parsing related options
     */
    [CCode (cname = "int", cprefix = "CMARK_OPT_", has_type_id = false)]
    [Flags]
    public enum OPT {
        DEFAULT,

        /**
        * Include a ``data−sourcepos`` attribute on all block elements.
        */
        SOURCEPOS,
        /**
        * Render ``softbreak`` elements as hard line breaks.
        */
        HARDBREAKS,
        /**
        * Suppress raw HTML and unsafe links
        *
        * Suppress (javascript:, vbscript:, file:, and data:,
        * except for image/png, image/gif, image/jpeg, or image/webp mime types).
        * Raw HTML is replaced by a placeholder HTML comment.
        * Unsafe links are replaced by empty strings.
        */
        SAFE,
        /**
        * Render ``softbreak`` elements as spaces.
        */
        NOBREAKS,

        /**
        * Legacy option (no effect).
        */
        NORMALIZE,
        /**
        * Validate UTF−8 in the input before parsing, replacing illegal sequences with the replacement character U+FFFD.
        */
        VALIDATE_UTF8,
        /**
        * Convert straight quotes to curly, −−− to em dashes, −− to en dashes.
        */
        SMART
    }


    [CCode (cname = "cmark_node_type", cprefix = "CMARK_NODE_", has_type_id = false)]
    public enum NODE_TYPE {
      /* Error status */
      NONE,

      /* Block */
      DOCUMENT,
      BLOCK_QUOTE,
      LIST,
      ITEM,
      CODE_BLOCK,
      HTML_BLOCK,
      CUSTOM_BLOCK,
      PARAGRAPH,
      HEADING,
      THEMATIC_BREAK,

      FIRST_BLOCK, // = DOCUMENT,
      LAST_BLOCK, // = THEMATIC_BREAK,

      /* Inline */
      TEXT,
      SOFTBREAK,
      LINEBREAK,
      CODE,
      HTML_INLINE,
      CUSTOM_INLINE,
      EMPH,
      STRONG,
      LINK,
      IMAGE,

      FIRST_INLINE, // = TEXT,
      LAST_INLINE // = IMAGE,
    }


    [CCode (cname = "cmark_list_type", has_type_id = false)]
    public enum LIST_TYPE {
        [CCode (cname="CMARK_NO_LIST")]
        NO_LIST,
        [CCode (cname="CMARK_BULLET_LIST")]
        BULLET,
        [CCode (cname="CMARK_ORDERED_LIST")]
        ORDERED
    }

    [CCode (cname = "cmark_delim_type", has_type_id = false)]
    public enum DELIM_TYPE {
        [CCode (cname="CMARK_NO_DELIM")]
        NO_DELIM,
        [CCode (cname="CMARK_PERION_DELIM")]
        PERIOD,
        [CCode (cname="CMARK_PAREN_DELIM")]
        PAREN
    }

    [CCode (cname = "cmark_event_type", cprefix = "CMARK_EVENT_", has_type_id = false)]
    public enum EVENT {
        NONE,
        DONE,
        ENTER,
        EXIT
    }

    /**
    * The library version as integer for runtime checks.
    *
    *
    *  * Bits 16−23 contain the major version.
    *  * Bits 8−15 contain the minor version.
    *  * Bits 0−7 contain the patchlevel.
    *
    * In hexadecimal format, the number 0x010203 represents version 1.2.3.
    */
    public int version();

    /**
    * The library version string for runtime checks.
    */
    public unowned string version_string();

    /**
    * Convert text from CommonMark Markdown to HTML.
    *
    * Convert text (assumed to be a UTF−8 encoded string) from CommonMark Markdown to HTML,
    * returning a null−terminated, UTF−8−encoded string.
    * It is the caller’s responsibility to free the returned buffer.
    */
    [CCode (cname="cmark_markdown_to_html")]
    public unowned string to_html([CCode (type="const char*", array_length_type = "size_t")] uint8[] text, OPT options);


    /**
    *
    */
    [Compact, CCode (cname = "struct cmark_node", cprefix = "cmark_node_", free_function = "cmark_node_free")]
    public class Node {
        /**
        * Parse a CommonMark document in buffer
        *
        * Returns a pointer to a tree of nodes.
        */
        [CCode(cname = "cmark_parse_document")]
        public static Node? parse_document([CCode (type="const char*", array_length_type = "size_t")] uint8[] text, OPT options);

        /**
        * Parse a CommonMark document in file.
        *
        * Returns a pointer to a tree of nodes.
        */
        [CCode(cname = "cmark_parse_file")]
        public static Node? parse_file(GLib.FileStream f, OPT options);

        /**
        * Creates a new node of type ``type``.
        *
        * Note that the node may have other required properties, which it is the caller’s responsibility to assign.
        */
        [CCode(cname = "cmark_node_new")]
        public Node(NODE_TYPE type);

        /**
        * Frees the memory allocated for a node and any children.
        */
        public void free();

        // Tree Traversal
        /**
        * Returns the next node in the sequence after node, or NULL if there is none
        */
        public unowned Node? next();
        /**
        * Returns the previous node in the sequence after node, or NULL if there is none.
        */
        public unowned Node? previous();
        /**
        * Returns the parent of node, or NULL if there is none.
        */
        public unowned Node? parent();
        /**
        * Returns the first child of node, or NULL if node has no children.
        */
        public unowned Node? first_child();
        /**
        * Returns the last child of node, or NULL if node has no children.
        */
        public unowned Node? last_child();

        // Accessors
        /**
        * Returns the user data of node.
        */
        [CCode (simple_generics = true)]
        public T? get_user_data<T>();
        /**
        * Sets arbitrary user data for node.
        *
        * Returns 1 on success, 0 on failure.
        */
        [CCode (simple_generics = true)]
        public int set_user_data<T>(T user_data);
        /**
        * Returns the type of node, or ``NODE_TYPE.NONE`` on error.
        */
        public NODE_TYPE get_type();
        /**
        * Like cmark_node_get_type, but returns a string representation of the type, or "<unknown>".
        */
        public unowned string get_type_string();
        /**
        * Returns the string contents of node, or an empty string if none is set.
        *
        * Returns NULL if called on a node that does not have string content.
        */
        public unowned string get_literal();
        /**
        * Sets the string contents of node.
        *
        * Returns 1 on success, 0 on failure.
        */
        public int set_literal(string content);
        /**
        * Returns the heading level of node, or 0 if node is not a heading.
        */
        public int get_heading_level();
        /**
        * Sets the heading level of node, returning 1 on success and 0 on error.
        */
        public int set_heading_level(int level);
        /**
        * Returns the list type of node, or ``LIST_TYPE.NO_LIST`` if node is not a list.
        */
        public LIST_TYPE get_list_type();
        /**
        * Sets the list type of node, returning 1 on success and 0 on error.
        */
        public int set_list_type(LIST_TYPE type);
        /**
        * Returns the list delimiter type of node, or ``DELIM_TYPE.NO_DELIM`` if node is not a list.
        */
        public DELIM_TYPE get_list_delim();
        /**
        * Sets the list delimiter type of node, returning 1 on success and 0 on error.
        */
        public int set_list_delim(DELIM_TYPE delim);
        /**
        * Returns starting number of node, if it is an ordered list, otherwise 0.
        */
        public int get_list_start();
        /**
        * Sets starting number of node, if it is an ordered list.
        *
        * Returns 1 on success, 0 on failure.
        */
        public int set_list_start(int start);
        /**
        * Returns 1 if node is a tight list, 0 otherwise.
        */
        public int get_list_tight();
        /**
        * Sets the "tightness" of a list.
        *
        * Returns 1 on success, 0 on failure.
        */
        public int set_list_tight(int tight);
        /**
        * Returns the info string from a fenced code block.
        */
        public unowned string get_fence_info();
        /**
        * Sets the info string in a fenced code block, returning 1 on success and 0 on failure.
        */
        public int set_fence_info(string info);
        /**
        * Returns the URL of a link or image node, or an empty string if no URL is set.
        *
        * Returns NULL if called on a node that is not a link or image.
        */
        public unowned string? get_url();
        /**
        * Sets the URL of a link or image node. Returns 1 on success, 0 on failure.
        */
        public int set_url(string url);
        /**
        * Returns the title of a link or image node, or an empty string if no title is set.
        *
        * Returns NULL if called on a node that is not a link or image.
        */
        public unowned string? get_title();
        /**
        * Sets the title of a link or image node.
        *
        * Returns 1 on success, 0 on failure.
        */
        public int set_title(string title);
        /**
        * Returns the literal "on enter" text for a custom node, or an empty string if no on_enter is set.
        *
        * Returns NULL if called on a non−custom node.
        */
        public unowned string? get_on_enter();
        /**
        * Sets the literal text to render "on enter" for a custom node.
        *
        * Any children of the node will be rendered after this text.
        * Returns 1 on success 0 on failure.
        */
        public int set_on_enter(string on_enter);
        /**
        * Returns the literal "on exit" text for a custom node, or an empty string if no on_exit is set.
        *
        * Returns NULL if called on a non−custom node.
        */
        public unowned string? get_on_exit();
        /**
        * Sets the literal text to render "on exit" for a custom node.
        *
        * Any children of the node will be rendered before this text.
        * Returns 1 on success 0 on failure.
        */
        public int set_on_exit(string on_exit);
        /**
        * Returns the line on which node begins.
        */
        public int get_start_line();
        /**
        * Returns the column at which node begins.
        */
        public int get_start_column();
        /**
        * Returns the line on which node ends.
        */
        public int get_end_line();
        /**
        * Returns the column at which node ends.
        */
        public int get_end_column();

        // Manupulate tree
        /**
        * Unlinks a node
        *
        * Unlinks a node, removing it from the tree, but not freeing its memory. (Use cmark_node_free for that.)
        */
        public void unlink();
        /**
        * Inserts sibling before node. Returns 1 on success, 0 on failure.
        */
        public int insert_before(Node sibling);
        /**
        * Inserts sibling after node. Returns 1 on success, 0 on failure.
        */
        public int insert_after(Node sibling);
        /**
        * Replaces oldnode with newnode and unlinks oldnode (but does not free its memory). Returns 1 on success, 0 on failure.
        */
        public int replace(Node newnode);
        /**
        * Adds child to the beginning of the children of node. Returns 1 on success, 0 on failure.
        */
        public int prepend_child(Node child);
        /**
        * Adds child to the end of the children of node. Returns 1 on success, 0 on failure.
        */
        public int append_child(Node child);
        /**
        * Consolidates adjacent text nodes.
        */
        [CCode(cname="cmark_consolidate_text_nodes")]
        public void consolidate_text_nodes();

        // Rendering
        /**
        * Render a node tree as XML.
        *
        * It is the caller’s responsibility to free the returned buffer.
        */
        [CCode (cname="cmark_render_xml")]
        public unowned string render_xml(OPT options);
        /**
        * Render a node tree as an HTML fragment.
        *
        * It is up to the user to add an appropriate header and footer.
        * It is the caller’s responsibility to free the returned buffer.
        */
        [CCode (cname="cmark_render_html")]
        public unowned string render_html(OPT options);
        /**
        * Render a node tree as a groff man page, without the header.
        *
        * It is the caller’s responsibility to free the returned buffer.
        */
        [CCode (cname="cmark_render_man")]
        public unowned string render_man(OPT options, int width);
        /**
        * Render a node tree as a commonmark document.
        *
        *  It is the caller’s responsibility to free the returned buffer.
        */
        [CCode (cname="cmark_render_commonmark")]
        public unowned string render_commonmark(OPT options, int width);
        /**
        * Render a node tree as a LaTeX document.
        *
        * It is the caller’s responsibility to free the returned buffer.
        */
        [CCode (cname="cmark_render_latex")]
        public unowned string render_latex(OPT options, int width);


        // TODO : more methods
    }

    /**
    * Iterator
    *
    * An iterator will walk through a tree of nodes, starting from a root node,
    * returning one node at a time, together with information about whether the
    * node is being entered or exited.
    *
    * The iterator will first descend to a child node, if there is one.
    * When there is no child, the iterator will go to the next sibling.
    * When there is no next sibling, the iterator will return to the parent
    * (but with an event type of EVENT.EXIT).
    * The iterator will return EVENT.DONE when it reaches the root node again.
    * One natural application is an HTML renderer, where an ENTER event outputs
    * an open tag and an EXIT event outputs a close tag.
    * An iterator might also be used to transform an AST in some systematic way,
    * for example, turning all level−3 headings into regular paragraphs.
    *
    * {{{
    *   void
    *   usage_example(Node root) {
    *       Iter iter = new Iter(node);
    *       EVENT evt;
    *       while ((evt = iter.next()) != EVENT.DONE) {
    *           unowned Node? cur = iter.get_node();
    *           // Do something with ‘cur‘ and ‘evt‘
    *       }
    *   }
    * }}}
    *
    * Iterators will never return EXIT events for leaf nodes, which are nodes of type:
    *
    *  * NODE_TYPE.HTML_BLOCK
    *  * NODE_TYPE.THEMATIC_BREAK
    *  * NODE_TYPE.CODE_BLOCK
    *  * NODE_TYPE.TEXT
    *  * NODE_TYPE.SOFTBREAK
    *  * NODE_TYPE.LINEBREAK
    *  * NODE_TYPE.CODE
    *  * NODE_TYPE.HTML_INLINE
    *
    * Nodes must only be modified after an EXIT event, or an ENTER event for leaf nodes.
    */
    [Compact, CCode (cname = "struct cmark_iter", cprefix = "cmark_iter_", free_function="cmark_iter_free")]
    public class Iter {
        [CCode(cname = "cmark_iter_new")]
        /**
        * Creates a new iterator starting at root.
        *
        * The current node and event type are undefined until cmark_iter_next is called for the first time.
        */
        public Iter(Node? root);
        /**
        * Frees the memory allocated for an iterator.
        */
        public void free();

        /**
        * Advances to the next node.
        *
        * Returns the event type (EVENT.ENTER, EVENT.EXIT or EVENT.DONE).
        */
        public EVENT next();

        /**
        *.Returns the current node.
        */
        public unowned Node? get_node();
        /**
        * Returns the current event type.
        */
        public EVENT get_event_type();
        /**
        * Returns the root node.
        */
        public unowned Node? get_root();

        /**
        * Resets the iterator.
        *
        * Resets the iterator so that the current node is current and the event type is event_type.
        * The new current node must be a descendant of the root node or the root node itself.
        */
        public void reset(Node current, EVENT event_type);
    }



    /**
    * Parsing
    *
    * Simple interface:
    *
    * {{{
    *   var node = Node.parse_document("Hello *world*".data, OPT.DEFAULT);
    * }}}
    *
    * Streaming interface:
    *
    * {{{
    *    var parser = new CMark.Parser(CMark.OPT.DEFAULT);
    *    var fp = GLib.FileStream.open("myfile.md", "rb");
    *    while ((bytes = fp.read(buf,1)) > 0) {
    *        parser.feed(buf, bytes);
    *    }
    *    var node = parser.finish();
    * }}}
    */
    [Compact, CCode (cname = "struct cmark_parser", cprefix = "cmark_parser_", free_function="cmark_parser_free")]
    public class Parser {
        [CCode(cname = "cmark_parser_new")]
        /**
        * Creates a new parser object.
        */
        public Parser(OPT options);

        /**
        * Frees memory allocated for a parser object.
        */
        void cmark_parser_free();

        /**
        * Feeds a string of length ``len`` to parser.
        */
        public void feed([CCode (type="const char*", array_length = false)] uint8[] buffer, size_t len);
        /**
        * Finish parsing and return a pointer to a tree of nodes.
        */
        public Node? finish();

    }
}
