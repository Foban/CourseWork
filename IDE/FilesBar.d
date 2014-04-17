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

import gtk.Image;
import gtk.TreeView;
import gtk.TreeStore;
import gtk.TreePath;
import gtk.TreeViewColumn;
import gtk.TreeIter;
import gtk.TreeSelection;
import gtk.CellRendererPixbuf;
import gtk.CellRendererText;
import gtk.ScrolledWindow;
import gdk.Pixbuf;
import glib.Str;

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

class FTreeStore : TreeStore{
	this(){
		GType[] columns;
		columns ~= GType.STRING;
		super(columns);
	}
}

class FilesBar : TreeView{
private:
	FTreeStore treeStore;
	TreeIter[string] iters;
	
public:
	this(){
		treeStore = new FTreeStore();
		super(treeStore);
		setRulesHint(true);

		TreeViewColumn column;

		column = new TreeViewColumn();

		CellRendererPixbuf cellPixbuf = new CellRendererPixbuf();
		CellRendererText cellText = new CellRendererText();

		column.packEnd(cellText, true);
		column.addAttribute(cellText, "text", 0);

		column.setTitle("Open documents");

		appendColumn(column);

		column.setResizable(true);
		column.setReorderable(true);
		column.setSortColumnId(0);
		column.setSortIndicator(true);
	}
	void add(string text){
		TreeIter iterTop = treeStore.createIter();
		treeStore.setValue(iterTop, 0, text);
		iters[text] = iterTop;
	}
	void remove(string text){
		treeStore.remove(iters[text]);
	}
}
