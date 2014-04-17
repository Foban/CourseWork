import gtk.Label;
import gtk.Main;
import gtkd.gtk.MainWindow;
//import parser;
import std.container;

////////////////////////
import std.stdio;
import std.stdint;
import std.string;
import std.algorithm;
import std.conv;
import std.range;
import std.regex;
import std.file;
import std.container;
import std.datetime;
import core.thread;

/////////////////////////
import std.stdio;
import std.file;
import gtk.TextView;
import gtk.TextBuffer;
import gtk.TextIter;
import gtk.VBox;
import gtk.HBox;
import stdlib = core.stdc.stdlib : exit;
import gtk.FileChooserDialog;
import gtk.ComboBox;
//////////////////////////

private import gtk.Image;
private import gtk.TreeView;
private import gtk.TreeStore;
private import gtk.TreePath;
private import gtk.TreeViewColumn;
private import gtk.TreeIter;
private import gtk.TreeSelection;
private import gtk.CellRendererPixbuf;
private import gtk.CellRendererText;
private import gtk.ScrolledWindow;
private import gdk.Pixbuf;
private import glib.Str;

/////////////////////////////
private import gtk.Window;

private import gtk.Widget;
private import gtk.TextView;
private import gtk.TextBuffer;
private import gtk.TextIter;
private import gtk.VPaned;
private import gtk.ScrolledWindow;
private import gtk.TextChildAnchor;
private import gtk.Button;
private import gtk.Menu;
private import gtk.MenuItem;
private import gtk.HScale;
private import gtk.Image;
private import gtk.Entry;

private import gdk.Pixbuf;

private import gtk.ComboBoxText;

private import glib.GException;

private import gtk.AccelGroup;
private import gtk.MenuBar;
private import gtk.Menu;
private import gtk.MenuItem;

import gtk.Frame;

class PTreeStore : TreeStore{
	this(){
		GType[] columns;
		columns ~= Pixbuf.getType();
		columns ~= GType.STRING;
		super(columns);
	}
}

class ProjectsBar : TreeView{
private:
	PTreeStore treeStore;
	TreeIter[string] iters;
	
public:
	this(){
		treeStore = new PTreeStore();
		super(treeStore);
		setRulesHint(true);

		TreeViewColumn column;

		column = new TreeViewColumn();

		CellRendererPixbuf cellPixbuf = new CellRendererPixbuf();
		CellRendererText cellText = new CellRendererText();

		column.packStart(cellPixbuf, false);
		column.addAttribute(cellPixbuf, "pixbuf", 0);

		column.packEnd(cellText, true);
		column.addAttribute(cellText, "text", 1);

		column.setTitle("Projects");

		appendColumn(column);

		column.setResizable(true);
		column.setReorderable(true);
		column.setSortColumnId(1);
		column.setSortIndicator(true);
	}
	
	void add(string text,string[string] files){
		writeln("Hy!");
		TreeIter iterChild;
		writeln("Hy!");
		TreeIter iterTop = treeStore.createIter();
		writeln("Hy!");
		treeStore.setValue(iterTop, 0, new Pixbuf(package_xpm) );
		writeln("Hy!");
		treeStore.setValue(iterTop, 1, text);
		writeln("Hy!");
		foreach(elem; files){
			writeln("^_^ :", elem);
			iterChild = treeStore.append(iterTop);
			treeStore.setValue(iterChild, 0, new Pixbuf(greenClass_xpm) );
			treeStore.setValue(iterChild, 1, elem);
		}
	//iters[text] = iterTop;
	}
}


	
/*void populate(TreeStore treeStore)
	{
		TreeIter iterChild;
		TreeIter iterTop = treeStore.createIter();
		treeStore.setValue(iterTop, 0, new Pixbuf(package_xpm) );
		treeStore.setValue(iterTop, 1, "Icon for packages" );

		iterChild = treeStore.append(iterTop);
		treeStore.setValue(iterChild, 0,new Pixbuf(greenTemplate_xpm) );
		treeStore.setValue(iterChild, 1, "Icon for templates" );

		iterChild = treeStore.append(iterTop);
		treeStore.setValue(iterChild, 0, new Pixbuf(greenInterface_xpm) );
		treeStore.setValue(iterChild, 1, "Icon for interfaces" );

		iterChild = treeStore.append(iterTop);
		treeStore.setValue(iterChild, 0, new Pixbuf(greenClass_xpm) );
		treeStore.setValue(iterChild, 1, "Icon for classes" );

	}*/
/* XPM */
	static string[] package_xpm = [
	"16 16 25 1",
	" 	c None",
	".	c #713C17",
	"+	c #BF8231",
	"@	c #C17A2D",
	"#	c #93551F",
	"$	c #C1772B",
	"%	c #DBBF9E",
	"&	c #E5C9A1",
	"*	c #CEAB8B",
	"=	c #9E7058",
	"-	c #BF752A",
	";	c #F9F1BB",
	">	c #EDD1A6",
	",	c #D7B897",
	"'	c #BB712A",
	")	c #D7B998",
	"!	c #B76D28",
	"~	c #C7A082",
	"{	c #794F40",
	"]	c #AE6325",
	"^	c #A96023",
	"/	c #A55C22",
	"(	c #A25922",
	"_	c #C58332",
	":	c #A05921",
	"                ",
	"       .        ",
	"  +@@@@#@@@@+   ",
	"  $%&&*=%&&*$   ",
	"  -&;>,=&;>,-   ",
	"  '&>>)=&>>)'   ",
	"  !*,)~{*,)~!   ",
	" .#==={{{===#.  ",
	"  ]%&&*{%&&*]   ",
	"  ^&;>,=&;>,^   ",
	"  /&>>)=&>>)/   ",
	"  (*,)~=*,)~(   ",
	"  _::::#::::_   ",
	"       .        ",
	"                ",
	"                "];
	
		/* XPM */
	static string[] greenClass_xpm = [
	"16 16 67 1",
	" 	c None",
	".	c #00CF2E",
	"+	c #005D14",
	"@	c #005A16",
	"#	c #005217",
	"$	c #004B15",
	"%	c #004413",
	"&	c #00BC23",
	"*	c #00BB23",
	"=	c #006A14",
	"-	c #000000",
	";	c #00B721",
	">	c #00BF25",
	",	c #006F17",
	"'	c #00821C",
	")	c #00801A",
	"!	c #007B17",
	"~	c #00C126",
	"{	c #FFFFFF",
	"]	c #00761A",
	"^	c #008B21",
	"/	c #00821B",
	"(	c #007316",
	"_	c #00BA22",
	":	c #A9EBB6",
	"<	c #007B1D",
	"[	c #009426",
	"}	c #A9F5BC",
	"|	c #A9F2BA",
	"1	c #00BA23",
	"2	c #00D935",
	"3	c #00BE25",
	"4	c #A9EDB7",
	"5	c #007F1F",
	"6	c #009C2A",
	"7	c #00ED3E",
	"8	c #00E339",
	"9	c #A9F1B9",
	"0	c #00CB2C",
	"a	c #00BE24",
	"b	c #00C729",
	"c	c #00BF26",
	"d	c #008120",
	"e	c #00A52E",
	"f	c #00F241",
	"g	c #00E53A",
	"h	c #00D933",
	"i	c #00841D",
	"j	c #007B18",
	"k	c #007F20",
	"l	c #009928",
	"m	c #009224",
	"n	c #008B20",
	"o	c #A9EFB8",
	"p	c #00801F",
	"q	c #00BC24",
	"r	c #00C82A",
	"s	c #007A1C",
	"t	c #00791C",
	"u	c #007117",
	"v	c #006B14",
	"w	c #00B822",
	"x	c #00C629",
	"y	c #A9E9B5",
	"z	c #A9E7B4",
	"A	c #00C127",
	"B	c #00CF2C",
	"                ",
	"      .+@#$%    ",
	"    &*=-----    ",
	"   ;>,--')!--   ",
	"  ~>{]-^{{/!(   ",
	"  _:{<-[}|{{1   ",
	" 234{5-67890a2  ",
	" bc4{d-efghij.  ",
	" 234{k--lmn--2  ",
	"  1:o{p-----_   ",
	"  q>ro{st]uv&   ",
	"   w>x4{{{{;    ",
	"    ~13yyzA     ",
	"      Bbh       ",
	"                ",
	"                "];