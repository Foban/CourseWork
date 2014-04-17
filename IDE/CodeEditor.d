import gtk.Label;
import gtkd.gtk.MainWindow;
import parser;

import std.string;
import std.conv;
import std.container;

/////////////////////////
import std.stdio;
import std.file;
import gtk.TextView;
import gtk.TextBuffer;
import gtk.TextIter;
import gtk.VBox;


import gtk.TextView;
import gtk.TextBuffer;
import gtk.TextIter;
import gtk.ScrolledWindow;
import gtk.TextChildAnchor;


import gtk.Frame;
import std.concurrency;
import glib.Timeout;
import core.time;
import core.atomic;
import gtk.TextTagTable;


void parseText(Tid tid, string filename, string text){
	parseBuffer[filename] ~= parse(text);
	parseStatusBuffer[filename] = false;
	writeln(false);
}

private TextBuffer[string] filesBuff;
private shared Lexeme[][string] parseBuffer;
private shared bool[string] parseStatusBuffer;

//Timeout timer  = new Timeout(100, &tester);

class CodeEditor : Frame{
private:
	TextView editor;
	Label openFile;
	TextTagTable styles;
	Timeout timer;
	
public:
	this(){
		super("");
		setLabelWidget(null);
		createTextView();
		createLabel();
		setSyntaxHighlightingStyle();
		setupWidgets();
		
		timer = new Timeout(100, &listener);
	}
	
	void closeText(){
		auto filename = openFile.getLabel();
		filesBuff[filename].setText(""); 
		filesBuff.remove(filename);
		parseBuffer.remove(filename);
		openFile.setLabel("Deleted");
	}
	
	bool openText(string filename){
		string text;
		if(filename !in filesBuff)
		{
			writefln("file selected = %s",filename);
			
			TextIter start = new TextIter();
			TextIter end = new TextIter();
			auto buffer = new TextBuffer(styles);
			buffer.setText(text = readText(filename));
			buffer.getBounds(start, end);
			buffer.applyTagByName("text", start, end);
			filesBuff[filename] = buffer;
			
			spawn(&parseText, thisTid, filename, text);
		}
		editor.setBuffer(filesBuff[filename]);
		openFile.setLabel(filename);
		return text==null ? false : true;
	}
	
	void createTextView(){
		editor = new TextView();
		editor.setLeftMargin(5);
		//textBuffer = editor.getBuffer();
	}
	void createLabel(){
		openFile  = new Label("text");
	}
	void setupWidgets(){
		ScrolledWindow sw = new ScrolledWindow(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
		sw.add(editor);
		VBox mainBox = new VBox(false, 0);										//компановка в виджет
		mainBox.packStart(openFile,false,true,0);
		mainBox.packStart(sw,true,true,0);	
		add(mainBox);
	}
	
	void setSyntaxHighlightingStyle(){
		TextBuffer buffer = editor.getBuffer();
		buffer.createTag("another","foreground","black");
		buffer.createTag("comment","foreground","green");
		buffer.createTag("number","foreground","red");
		buffer.createTag("word","foreground","black");
		buffer.createTag("symbol","foreground","grey");
		buffer.createTag("string","foreground","green");
		buffer.createTag("bracket","foreground","black");
		buffer.createTag("bracket_open","foreground","black");
		buffer.createTag("bracket_close","foreground","black");
		buffer.createTag("default","foreground","black");
		buffer.createTag("reservedTypes","foreground","#0000CD");
		buffer.createTag("keywords","foreground","#A52A2A");
		buffer.createTag("text", "size", 13 * PANGO_SCALE);
		styles = buffer.getTagTable();
	}

	bool listener(){
		foreach(elem;parseStatusBuffer.byKey){
			if(!parseStatusBuffer[elem]){
				makeSyntaxHighlighting(parseBuffer[elem], elem);
				parseStatusBuffer[elem] = true;
			}
		}
		return true;
	}
	void makeSyntaxHighlighting(shared Lexeme[] lex, string filename){
		TextIter iterBegin = new TextIter();
		TextIter iterEnd = new TextIter();
		auto textBuffer  = filesBuff[filename];
		textBuffer.getStartIter(iterBegin);
		textBuffer.getStartIter(iterEnd);
		foreach(elem; lex)
		{	
			iterBegin.setOffset(elem.begin);
			iterEnd.setOffset(elem.end);
			textBuffer.applyTagByName(TypeName[elem.type],iterBegin,iterEnd);
		}
	}
	string nameOfOpenText(){
		return openFile.getLabel();
	}
}