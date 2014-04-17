import gtkd.gtk.MainWindow;
import gtk.Main;
import gtk.AccelGroup;
import gtk.MenuBar;
import gtk.Menu;
import gtk.MenuItem;
import std.stdio;
import std.file;
import parser;
import std.container;
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
import stdlib = core.stdc.stdlib : exit;
import gtk.FileChooserDialog;
import gtk.VBox;
import gtk.HBox;
import gtk.HPaned;

import gtk.TreeView;
import gtk.TreeStore;
import gtk.TreePath;
import gtk.TreeViewColumn;
import gtk.TreeIter;

import CodeEditor;
import FilesBar;
import ProjectsBar;
import gtk.HandleBox;
import gtk.Toolbar;
import gtk.ToolButton;
import gtk.SeparatorToolItem;

class IDEToolbar : Toolbar{
	this(){
		insert(new ToolButton(StockID.OPEN));
		insert(new ToolButton(StockID.CLOSE));
		insert(new SeparatorToolItem());
		insert(new ToolButton(StockID.SAVE));
		insert(new ToolButton(StockID.SAVE_AS));
		insert(new SeparatorToolItem());
		insert(new ToolButton(StockID.MEDIA_PLAY));
		insert(new ToolButton(StockID.PREFERENCES));
	}
}