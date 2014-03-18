import gtk.MainWindow;
import gtk.Label;
import gtk.Main;
private import gtk.ButtonBox;
private import gtk.FileChooserButton;

/////////////////////////////////////////////
private import gtk.MenuItem;
private import gtk.Widget;
private import gtk.MenuBar;
private import gtk.Notebook;
private import gtk.ComboBoxText;
private import gtk.FileChooserDialog;
private import gtk.FontSelectionDialog;
private import gtk.ColorSelectionDialog;
private import gtk.Button;
private import gtk.VBox;
private import gtk.MessageDialog;
private import gtk.Frame;
private import gtk.HButtonBox;
private import gtk.Statusbar;
private import gtk.Menu;
private import gtk.HandleBox;
private import gtk.Toolbar;
private import gtk.SeparatorToolItem;
private import gtk.ToolButton;
private import gtk.RadioButton;
private import gtk.CheckButton;
private import gtk.ToggleButton;
//private import gtk.ListItem;
private import gtk.HBox;
private import gtk.Arrow;
//private import gtk.ListG;
//private import gtk.OptionMenu;
private import gtk.ButtonBox;
private import gtk.FileChooserButton;
private import gtk.Calendar;
private import gtk.VButtonBox;
private import gtk.SpinButton;
private import gtk.ListStore;
private import gtk.TreeIter;
private import gtk.TreeView;
private import gtk.TreeViewColumn;
private import gtk.CellRendererText;
//private import gtk.SListG;
//private import ddi.Drawable;
private import gtk.Window;

private import gtk.ScrolledWindow;
private import gtk.MessageDialog;

private import core.memory;

private import glib.ListSG;

private import glib.Str;
private import gtk.Label;
private import glib.ListG;
private import gtk.Paned;
private import gtk.HPaned;
private import gtk.VPaned;

private import gtk.Calendar;
private import std.stdio;
private import gtk.VButtonBox;
private import gtk.FileChooserButton;

private import gtk.AboutDialog;
private import gtk.Dialog;

private import gtk.TreeStore;
private import gdk.Pixbuf;
private import gtk.ComboBox;

private import gtk.TreePath;
private import gtk.CellRenderer;
private import gtk.CellRendererPixbuf;


version(cairo)private import cairo.clock;

private import gtk.Version;
private import gtk.Table;

private import stdlib = core.stdc.stdlib : exit;
private import core.thread;
private import std.random;

import gdk.Threads;
private import gsv.SourceView;
private import gsv.SourceBuffer;
private import gsv.SourceLanguage;
private import gsv.SourceLanguageManager;


import std.stdio;
import std.file;
////////////////////////////////////////////

// dmd hello.d gtkd.lib gtkdsv.lib -m64

class IDEMainWindow : MainWindow{

private:
	Button openFileDialogButton;
	Button cancelButton;
	Button quitButton;
	VBox bBox;
	SourceView editor;
	SourceBuffer editorBuffer;
	string[string] filesBuff;
	ScrolledWindow scrolledWindow;
	HBox mainBox;
	ComboBoxText filesBox;
	SourceLanguage dLang;

public:

	this()
	{
		super("IDE Main Window write on gtkd");
		
		openFileDialogButton = new Button("Open File", &openFile);			//настройка и расположение кнопок
		cancelButton = new Button(StockID.CANCEL, &exit);
		quitButton = new Button(StockID.OK, &exit);
		filesBox = new ComboBoxText(false);
		filesBox.addOnChanged(&selectOpenFile);
		
		bBox =  new VBox(false,0);

		bBox.packStart(openFileDialogButton,false,false,0);
		bBox.packStart(cancelButton,false,false,0);
		bBox.packStart(quitButton,false,false,0);
		bBox.packStart(filesBox,false,false,0);
		
		editor = new SourceView;											//настройка редактора
		
		editor.setShowLineMarks (true);
		editor.setShowLineNumbers(true);
		editor.setInsertSpacesInsteadOfTabs(false);
		editor.setHighlightCurrentLine(true);
		editor.setShowLineNumbers(true);
		editor.setRightMarginPosition(72);
		editor.setShowRightMargin(true);
		editor.setAutoIndent(true);
		
			
		editorBuffer = editor.getBuffer();									//буффер
		
		scrolledWindow = new ScrolledWindow();								//скрол редактора
		scrolledWindow.add(editor);
		
		SourceLanguageManager slm = new SourceLanguageManager();			//активация подсветки синтексиса
		dLang = slm.getLanguage("d");
		
		editorBuffer.setLanguage(dLang);
		editorBuffer.setHighlightSyntax(true);
		
		mainBox = new HBox(false, 0);										//компановка в виджет
		mainBox.packStart(bBox, false, false,0);
		mainBox.packStart(scrolledWindow, true, true,0);
		
		add(mainBox);
	}
		
	void exit(Button button)
	{
		stdlib.exit(0);
	}

	void selectOpenFile(ComboBoxText combobox)
	{
		auto s = filesBox.getActiveText();
		if(s in filesBuff)
		{
			editorBuffer.setText(filesBuff[s]);
			writeln(s);
		}
	}
	
	void openFile(Button button)
	{	
		string[] a;
		ResponseType[] r;
		r ~= ResponseType.OK;
		r ~= ResponseType.CANCEL;
		auto fcd = new FileChooserDialog("File Chooser", this, FileChooserAction.OPEN, a, r);
		

		fcd.setSelectMultiple(false);
		fcd.run();
		string filename = fcd.getFilename();
		if(filename != "")
		{
			if(filename !in filesBuff)
			{
				writefln("file selected = %s",filename);
				filesBuff[filename]=readText(filename);
				editorBuffer.setText(filesBuff[filename]);
			}
			filesBox.setActiveText(filename, true);
		}
//		writeln(fcd.getPreviewWidgetActive());
//
//		foreach ( int i, string selection ; fs.getSelections())
//		{
//			writeln("File(s) selected [%d] %s",i,selection);
//		}
		try{
		}
		catch(Throwable r){writeln("ups!!");};
		fcd.hide();
	}
}
	
void main(string[] args)
{
    Main.init(args);
	writeln("ups");
    MainWindow win2 = new IDEMainWindow;
    win2.setDefaultSize(700, 700);
    win2.showAll();
    Main.run();
}