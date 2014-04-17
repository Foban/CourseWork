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
import gtk.Window;

import gtk.Widget;
import gtk.TextView;
import gtk.TextBuffer;
import gtk.TextIter;
import gtk.VPaned;
import gtk.ScrolledWindow;
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
import IDEToolbar;
import project_manager;
import gtk.FileFilter;
import gtk.FileChooserIF;
import gtk.FileChooserButton;



FileChooserDialog fcd;

class IDEMainWindow : MainWindow{

private:
	CodeEditor editor;
	FilesBar filesBar;
	ProjectsBar projectsBar;
	VBox mainBox;
	MenuBar menuBar;
	IDEToolbar toolbar;
	ProjectManager manager;

public:

	this()
	{
		super("IDE Main Window write on gtkd");
		createEditor();
		createFilesBar();
		createMenuBar();
		createProjectsBar();
		createToolbar();
		setupWidgets();
		manager = new ProjectManager;
	}
	
	void createEditor(){
		editor = new CodeEditor;
	}	
	void createMenuBar(){
		AccelGroup accelGroup = new AccelGroup();

		addAccelGroup(accelGroup);
		menuBar = new MenuBar();
		Menu menu = menuBar.append("_File");

		menu.append(new MenuItem(&onMenuActivate, "New","file.new", true, accelGroup, 'n'));
		menu.append(new MenuItem(&openFile, "Open file","file.open", true, accelGroup, 'o'));
		menu.append(new MenuItem(&openProject, "Open project","file.open", true, accelGroup,'o', GdkModifierType.CONTROL_MASK|GdkModifierType.SHIFT_MASK));
		menu.append(new MenuItem(&onMenuActivate, "Save file","file.save", true, accelGroup, 's'));
		menu.append(new MenuItem(&onMenuActivate, "Save all files","file.save_all", true, accelGroup, 's', GdkModifierType.CONTROL_MASK|GdkModifierType.SHIFT_MASK));
		menu.append(new MenuItem(&onMenuActivate, "Save file as...","file.save_as", true, accelGroup));
		menu.append(new MenuItem(&closeFile, "Close","file.close", true, accelGroup));
		menu.append(new MenuItem(&exit, "Exit","file.exit", true, accelGroup, 'x'));

		menu = menuBar.append("_Edit");

		menu.append(new MenuItem(&onMenuActivate,"_Find","edit.find", true, accelGroup, 'f'));

		menu = menuBar.append("_Help");
		menu.append(new MenuItem(&onMenuActivate,"_About","help.about", true, accelGroup, 'a',GdkModifierType.CONTROL_MASK|GdkModifierType.SHIFT_MASK));
	}
	void createFilesBar(){
		filesBar = new FilesBar;
		filesBar.addOnRowActivated(&selectOpenFile);
	}
	void createProjectsBar(){
		projectsBar = new ProjectsBar;
	}
	void createToolbar(){
		toolbar = new IDEToolbar;
	}

	void setupWidgets(){	
		HPaned hPaned = new HPaned();
		hPaned.setBorderWidth(2);
		VPaned vPaned = new VPaned();
		vPaned.setBorderWidth(0);
		
		vPaned.add(projectsBar, filesBar);
		vPaned.setPosition(400);
		hPaned.add(vPaned, editor);
	
		
		mainBox = new VBox(false, 0);										//компановка в виджет
		mainBox.packStart(menuBar,false,false,0);
		mainBox.packStart(toolbar, false,false,0);
		mainBox.packStart(hPaned, true, true, false);
		//mainBox.packStart(fcb, true, true, false);	
		
		add(mainBox);
	}
	
	
	FileChooserDialog getOpenDialog(string patern){
		auto fcd =  new FileChooserDialog("File Chooser", this, FileChooserAction.OPEN);
		new FileChooserButton(fcd);											//хехей :D магия в коде :)
		fcd.setLocalOnly(true);
		auto filter = new FileFilter;
		fcd.setSelectMultiple(true);
		filter.addPattern(patern);
		fcd.setFilter(filter);
		fcd.run();		
		fcd.hide();
		return fcd;
	}

	
	void onMenuActivate(MenuItem menuItem){
		string action = menuItem.getActionName();
		writeln(action);
	}
	
	void exit(MenuItem menuItem){
		stdlib.exit(0);
	}
	void closeFile(MenuItem menuItem){
		string text = editor.nameOfOpenText;
		if(text != "Deleted" && text != "text"){
			filesBar.remove(text);
			editor.closeText();
		}
	}
	
		
	void openFile(MenuItem menuItem){
		auto fcd = getOpenDialog("*.d");
		string filename = fcd.getFilename();
		if(filename != "" && filename.isFile){
			if(editor.openText(filename))
				filesBar.add(filename);
		}
		fcd.hide();
	}
	void openProject(MenuItem menuItem){
		auto fcd = getOpenDialog("*.dpr");
		string filename = fcd.getFilename();
		if(filename != "" && filename.isFile){
			if(manager.openProject(filename)){
				writeln("Hi-Hi! :)",filename);
				projectsBar.add(filename, manager.getFiles(filename));
			}
		}
	}
	
		
	void selectOpenFile(TreePath treep, TreeViewColumn treec, TreeView tree){
		auto iter = new TreeIter(tree.getModel(),treep);
		auto filename = iter.getValueString(0);
		if(editor.nameOfOpenText() != filename){
			editor.openText(filename);
		}
	}
	
/*
	
	void selectOpenFile(ComboBoxText combobox)
	{
		auto filename = filesBox.getActiveText();
		if(filename in filesBuff)
		{
			textBuffer.setText(filesBuff[filename]);
			makeSyntaxHighlighting(filename);
		}
	}
	
	void saveFileAs(MenuItem menuItem)
	{
		string[] a;
		ResponseType[] r;
		r ~= ResponseType.OK;
		r ~= ResponseType.CANCEL;
		auto fcd = new FileChooserDialog("File Chooser", this, FileChooserAction.SAVE, a, r);
		

		//fcd.setSelectMultiple(false);
		fcd.run();
		string filename = fcd.getFilename();
		if(filename != "")
		{
			//writefln("file selected = %s",filename);
			std.file.write(filename, textBuffer.getText());
			//buffer.setText=readText(filename);
		}
		fcd.hide();
	}
	
	void saveFile(MenuItem menuItem)
	{
		auto filename = filesBox.getActiveText();
		if(filename != "default")
			std.file.write(filename, textBuffer.getText());
		else
			saveFileAs(menuItem);
	}
	
	void saveAllFiles(MenuItem menuItem){}
	
	void closeFile(MenuItem menuItem)
	{
		if(filesBox.getActive() != -1)
		{
			auto filename = filesBox.getActiveText();
			if(filename != "default")
			{
				filesBox.remove(filesBox.getActive());
				filesBuff.remove(filename);
				textBuffer.setText = "";
				parseBuffer.remove(filename);
			}
			
		}
	}
	
	void setSyntaxHighlightingStyle()
	{
		textBuffer.createTag("another","foreground","black");
		textBuffer.createTag("comment","foreground","green");
		textBuffer.createTag("number","foreground","red");
		textBuffer.createTag("word","foreground","black");
		textBuffer.createTag("symbol","foreground","grey");
		textBuffer.createTag("string","foreground","green");
		textBuffer.createTag("bracket","foreground","black");
		textBuffer.createTag("bracket_open","foreground","black");
		textBuffer.createTag("bracket_close","foreground","black");
		textBuffer.createTag("default","foreground","black");
		textBuffer.createTag("reservedTypes","foreground","#0000CD");
		textBuffer.createTag("keywords","foreground","#A52A2A");
	}
	
	void makeSyntaxHighlighting(string filename)
	{
		TextIter iterBegin = new TextIter();
		TextIter iterEnd = new TextIter();
		textBuffer.getStartIter(iterBegin);
		textBuffer.getStartIter(iterEnd);
		foreach(elem; parseBuffer[filename])
		{
			iterBegin.setOffset(elem.begin);
			iterEnd.setOffset(elem.end);
			textBuffer.applyTagByName(TypeName[elem.type],iterBegin,iterEnd);
		}
	}
	*/
}