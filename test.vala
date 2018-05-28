

void dump_node(CMark.Node? node, int i=0) {
    if (node == null) return;
    var type = node.get_type_string();
    var content = node.get_literal();
    //var content = "";

    for(int k=0; k<i; k++) print("|"); print("\\");
    print("%s : %s\n", type, content);
    
    
    dump_node(node.first_child(),i+1);
    
    dump_node(node.next(), i);
    
}

void main () {
    var testmd = """
# Tile

text **bold** *italic* normal.

* list 1
* list 2
    * list 2.1
""";

    var version = CMark.version();
    var versionstr = CMark.version_string();
    print ("CMark version 0x%06x : %s\n\n\n", version, versionstr);
    
    string html = CMark.to_html(testmd.data, CMark.OPT.DEFAULT);
    print("%s\n\n\n", html);
    
    {
        CMark.Node node = new CMark.Node(CMark.NODE_TYPE.DOCUMENT);
        print("node user data: %s\n", node.get_user_data<unowned string>());
        print("node type: %d : %s\n\n\n", node.get_type(), node.get_type_string());
    }
    
    {
        CMark.Node node = CMark.Node.parse_document(testmd.data, CMark.OPT.DEFAULT);
        dump_node(node);

        print("\n\n");
        
        CMark.Iter iter = new CMark.Iter(node);
        CMark.EVENT evt;
        while ((evt  = iter.next()) != CMark.EVENT.DONE) {
            unowned CMark.Node? cnode = iter.get_node();

            if (evt == CMark.EVENT.EXIT) {
                print("</%s>\n", cnode.get_type_string());
            }
            
            if (evt == CMark.EVENT.ENTER) {
                print("<%s>\n", cnode.get_type_string());
                if (cnode.get_literal() != null) {
                    print("%s\n",cnode.get_literal());
                }
            }
        }

        print("\n\n");
        
        print(node.render_xml(0));
        print("\n\n");
        print(node.render_html(0));
        print("\n\n");
        print(node.render_man(0,80));
        print("\n\n");
        print(node.render_commonmark(0,80));
        print("\n\n");
        print(node.render_latex(0,80));
        
    }
    
    {
        print ("\n\nparsefile\n\n");
        var f = GLib.FileStream.open("test.md", "r");
        assert (f != null);
        var node = CMark.Node.parse_file(f, CMark.OPT.DEFAULT);
        print(node.render_xml(CMark.OPT.DEFAULT));
    }
    
    {
        print ("\n\nstreaming\n\n");
        var parser = new CMark.Parser(CMark.OPT.DEFAULT);
        var fp = GLib.FileStream.open("test.md", "r");
        assert (fp != null);
        size_t bytes;
        uint8[] buf = new uint8[10];
        while ((bytes = fp.read(buf, 1)) > 0) {
            parser.feed(buf, bytes);
        }
        var node = parser.finish();
        print(node.render_xml(CMark.OPT.DEFAULT));
    
    }

}







