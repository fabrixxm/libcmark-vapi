void main () {
    var testmd = """
# Tile

text **bold** *italic* normal.

* list
* list
    * list
""";

    var version = CMark.version();
    var versionstr = CMark.version_string();
    print ("CMark version 0x%06x : %s\n", version, versionstr);
    
    string html = CMark.to_html(testmd.data, CMark.OPT.DEFAULT);
    print(html);
    free(html);
}   
