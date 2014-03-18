import std.stdio;
import std.process;
import std.string;
import std.stdint;
import std.container;
import std.file;
import std.range;
import std.conv;

import help_function;
import error;


interface ProjectInterface
{
	void makeProjectFile();
	
	bool bild();
	void startProject();
	
	bool addFile(string file);
	bool addNewFile(string file);
	
	void removeAllFiles();
	void removeFile(string key);
	
	void deleteFile(string key);
	void deleteAllFiles();
	
	void changeProjectName(string newName);
	void changeCompileParameters(string parametrs);
	void changeBildStatus(bool );
	
	string[string] getFiles();
	string getName();
}

class Project : ProjectInterface
{
private:
	string projectFilePath;
	string[string] files;
	string path;
	string name;
	string compileParameters;
	bool bildStatus = false;
	
public:

	this(string projectDirectory, string projectName)   // new project
	{	
		string wpath = projectDirectory~FSep~projectName;
		if(!exists(wpath))
			if(!exists(wpath~FSep~projectName~".dpr"))
			{
				mkdirRecurse(wpath);
				mkdir(wpath~FSep~"Debug");
				mkdir(wpath~FSep~"Release");
			
				path = wpath;
				projectFilePath = path~FSep~projectName~".dpr";
				name = projectName;
				compileParameters = "dmd -debug -of"~path~FSep~"Debug"~FSep~name;
				makeProjectFile();
			}
			else
				throw new ProjectException("Such file is already exist");
		else
			throw new ProjectException("Such folder is already exist");
	}
	
	this(string projectFile)									// open project
	{
		if(exists(projectFile))
		{
			projectFilePath = projectFile;
			auto file = File(projectFilePath);
			name = strip(file.readln());
			path = strip(file.readln());
			compileParameters = "dmd -debug -of"~path~FSep~"Debug"~FSep~name;
			string line;
			bool remake = false;
			while(!file.eof())
			{	
				line = strip(file.readln());
				if(exists(line))
					files[line] = line;
				else remake = true;
			}
			file.close();
			if(remake)
				makeProjectFile();
		}
		else
			throw new ProjectException("Such file is not exist");
	}
	
	void makeProjectFile()
	{	
		auto file = File(projectFilePath, "w");
		file.write(name,'\n',path,compareFiles('\n'));
		file.close();
	}
	
	bool bild()
	{	
		auto compiler = executeShell(compileParameters~compareFiles(' '));
		if(compiler.status) 
		{
			writeln(compiler.output);
			return false;
		}
		bildStatus = true;
		return true;
	} 
	
	void startProject()
	{
		if(bildStatus)
		{
			start();
		}
		else if(bild())
		{
			start();
		}
	}

	bool addFile(string file)						// true если файл существует
	{
		if(exists(file))
		{
			if(file !in files)
			{
				append(projectFilePath, '\n'~file);
				files[file] = file;
			}
			return true;
		}
		else
			return false;
	}
	
	string getName()
	{
		return name;
	}
	
	bool addNewFile(string file)					// true если файл не существовал
	{
		if(!exists(file))
		{
			File(file, "w");
			if(file !in files)
			{
				append(projectFilePath, file~'\n');
				files[file] = file;
			}
			return true;
		}
		else
			return false;
	}
	
	string[string] getFiles()
	{
		return files.dup;
	}
	
	void removeAllFiles()							// исключить из проекта 
	{
		files = null;
	}
	
	void removeFile(string key)
	{
		files.remove(key);
	}
		
	void deleteFile(string key)						// исключить из проекта и удалить из памяти компьютера
	{
		removeFile(key);
		hello();
	}
	
	void deleteAllFiles()
	{
		removeAllFiles();
		hello();
	}
	
	void changeProjectName(string newName)
	{
		name = newName;
		makeProjectFile();
	}
	
	void changeCompileParameters(string parametrs)
	{
		compileParameters = parametrs;
	}
	
	void changeBildStatus(bool status)
	{
		bildStatus = status;
	}
	
private:
	string compareFiles(char sep)
	{
		string path;
		foreach(file; files)
		{
			path ~= sep ~ file;
		}
		return path;
	}
	
	void start()
	{
		writeln("Starting program...");
		system(path~FSep~"Debug"~FSep~name);
		writeln("Program end");
	}
	
}

