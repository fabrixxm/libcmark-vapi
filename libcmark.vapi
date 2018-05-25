/*
 * Copyright (c) 2018 Fabio Comuni <fabrix.xm@gmail.com>
 * 
 * This library is released under BDS license
 *
 * https://github.com/commonmark/cmark
 * $ zcat /usr/share/man/man3/cmark.3.gz | roff2html > cmark.hmtl
 *
 * https://wiki.gnome.org/Projects/Vala/LegacyBindings
 * https://wiki.gnome.org/Projects/Vala/FAQ
 * https://wiki.gnome.org/Projects/Vala/ReferenceHandling#Unowned_References
 */
 
[CCode (cprefix = "cmark_", cheader_filename = "cmark.h")]
namespace CMark {

    [CCode (cname = "int", cprefix = "CMARK_OPT_", has_type_id = false)]
    [Flags]
    public enum OPT {
        DEFAULT,
        SOURCEPOS,
        HARDBREAKS,
        SAFE,
        NOBREAKS,
        NORMALIZE,
        VALIDATE_UTF8,
        SMART
    }


    [CCode (cname = "cmark_node_type", cprefix = "CMARK_NODE_", has_type_id = false)]
    public enum NODE {
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
    public enum LIST {
        [CCode (cname="CMARK_NO_LIST")]
        NO,
        [CCode (cname="CMARK_BULLET_LIST")]
        BULLET,
        [CCode (cname="CMARK_ORDERED_LIST")]
        ORDERED
    }

    [CCode (cname = "cmark_delim_type", has_type_id = false)]    
    public enum DELIM {
        [CCode (cname="CMARK_NO_DELIM")]
        NO,
        [CCode (cname="CMARK_PERION_DELIM")]
        PERIOD,
        [CCode (cname="CMARK_PAREN_DELIM")]
        PAREN
    }    
    
    

    /**
    */
    int version();
    
    /**
    */
    unowned string version_string();
    
    /**
    * Simple Interface
    *
    * Convert text (assumed to be a UTF−8 encoded string) from CommonMark Markdown to HTML, 
    * returning a null−terminated, UTF−8−encoded string. 
    * It is the caller’s responsibility to free the returned buffer.
    */
    [CCode (cname="cmark_markdown_to_html")]
    unowned string to_html([CCode (type="const char*", array_length_type = "size_t")] uint8[] text, OPT options);
}
