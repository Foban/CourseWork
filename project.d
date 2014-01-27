import std.stdio;
import std.process;
import std.string;
import std.stdint;
import std.container;
import std.file;

import help_function;

class Project
{
public:
	/*this(string path)
	{
		
	}
	
	this(string name, string path)
	{
		
	}*/
	
	bool bild()
	{
		writeln("Building program...");
		system("dmd -w -release -ofRealise\\IDE"~path);
		return true;
	}
	
	void start()
	{
		if(!bildStatus) bild();
		writeln("Starting program...");
		system("Realise\\IDE");
		writeln("Program end");
	}

	bool addFile(string file)
	{
		if(exists(file))
		{
			files.insert(file);
			return true;
		}
		else
			return false;
	}
	
	bool addNewFile(string file)
	{
		if(!exists(file))
		{
			files.insert(file);
			return true;
		}
		else
			return false;
	}

	Array!string getFiles()
	{
		return files.dup;
	}

	string getFile(int index)
	{
		return files[index].dup;
	}
	
	void clear()
	{
		files.clear();
	}
	
	bool deleteFile(int index)
	{
		hello();
		return false;
	}
	
private:
	Array!string files;
	string path;
	string name;
	string compileParameters;
	bool bildStatus;
}

