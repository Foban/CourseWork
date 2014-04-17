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

struct Project
{
	string projectFilePath;
	string[string] files;
	string path;
	string name;
	string compileDebug;
	string compileRelease;
	bool buildStatus = false;
	bool debugStatus = true;
}

class ProjectManager
{
private:
	Project[string] projects;
	string compileParametersDebug = "dmd -debug";	
	string compileParametersRelease = "dmd -debug";
	string console = "konsole";

private:
	void _openProject(string projectFile){
		if(exists(projectFile))
		{
			Project project;
			project.projectFilePath = projectFile;
			auto file = File(projectFile);
			project.name = strip(file.readln());
			project.path = strip(file.readln());
			project.compileDebug = strip(file.readln());
			project.compileRelease = strip(file.readln());
			string line;
			bool remake = false;
			while(!file.eof())
			{	
				line = strip(file.readln());
				if(line !in project.files && line != "")
					project.files[line] = line;
				else remake = true;
			}
			file.close();
			projects[projectFile] = project;
			if(remake)
				makeProjectFile(projectFile);
		}
		else
			throw new ProjectException("Such file is not exist");
	}
	string compareFiles(string[string] files, char sep){
		string path;
		foreach(file; files)
		{
			path ~= sep ~ file;
		}
		return path;
	}
	void start(string project){
		writeln("Starting program...");
			system(console~ " -noclose -e" ~ " " ~ projects[project].path ~ FSep ~ (projects[project].debugStatus ? "Debug" : "Release") ~ FSep ~ projects[project].name);
		writeln("Program end");
	}
	
public:
	this(){}
	this(string projectFile){									// open project
		_openProject(projectFile);
	}
	
	void makeProject(string projectDirectory, string projectName){	
		string wpath = projectDirectory~FSep~projectName;
		if(!exists(wpath))
			if(!exists(wpath~FSep~projectName~".dpr"))
			{
				Project newProject;
				mkdirRecurse(wpath);
				mkdir(wpath~FSep~"Debug");
				mkdir(wpath~FSep~"Release");
			
				newProject.path = wpath;
				newProject.projectFilePath = wpath~FSep~projectName~".dpr";
				newProject.name = projectName;
				newProject.compileDebug = "-of"~wpath~FSep~"Debug"~FSep~projectName;
				newProject.compileRelease = "-of"~wpath~FSep~"Release"~FSep~projectName;				
				projects[newProject.projectFilePath] = newProject;
				makeProjectFile(newProject.projectFilePath);
			}
			else
				throw new ProjectException("Such file is already exist");
		else
			throw new ProjectException("Such folder is already exist");
	}

	bool openProject(string projectFile){
		if(projectFile !in projects){
			_openProject(projectFile);
			return true;
		}
		return false;
	}
	
	void makeProjectFile(string projectFilePath){	
		auto file = File(projectFilePath, "w");
		auto project =projects[projectFilePath];
		file.write(project.name, '\n', project.path,"\n",project.compileDebug, "\n",project.compileRelease, compareFiles(project.files,'\n'));
		file.close();
	}
	
	bool bild(string projectFile)	{
		auto project =projects[projectFile];
		auto parametrs = (project.debugStatus ? (compileParametersDebug ~ " " ~ project.compileDebug) : (compileParametersRelease ~ " " ~ project.compileRelease));
		auto compiler = executeShell(parametrs ~ " " ~ compareFiles(project.files,' '));
		if(compiler.status) 
		{
			writeln(compiler.output);
			return false;
		}
		projects[projectFile].buildStatus = true;
		return true;
	} 
	void startProject(string projectFile){
		if(projects[projectFile].buildStatus)
		{
			start(projectFile);
		}
		else if(bild(projectFile))
		{
			start(projectFile);
		}
	}

	bool addFile(string project, string file){
		if(exists(file))
		{
			if(file !in projects[project].files)
			{
				append(project, '\n'~file);
				projects[project].files[file] = file;
			}
			return true;
		}
		else
			return false;
	}
	bool addNewFile(string project, string file){
		if(!exists(file))
		{
			File(file, "w");
			if(file !in projects[project].files)
			{
				append(project, '\n'~file);
				projects[project].files[file] = file;
			}
			return true;
		}
		else
			return false;
	}
	
	void changeProjectName(string project,string newName){
		projects[project].name = newName;
		makeProjectFile(project);
	}
	void changeCompileParametersDebug(string parametrs){
		compileParametersRelease = parametrs;
	}
	void changeCompileParametersRelease(string parametrs){
		compileParametersDebug = parametrs;
	}
	void changeProjectDebugParametrs(string project, string parametrs){
		projects[project].compileDebug = parametrs;
	}
	void changeProjectReleaseParametrs(string project, string parametrs){
		projects[project].compileRelease = parametrs;
	}
	void changeBuildStatus(string project, bool status){
		projects[project].buildStatus = status;
	}
	void changeDebugStatus(string project, bool status){
		projects[project].debugStatus = status;
	}
	
	string[string] getFiles(string project){
		return projects[project].files;
	}
	string getName(string project){
		return projects[project].name;
	}
	string getProjectDir(string project){
		return projects[project].path;
	}
	
	void removeAllFiles(string project){						// исключить из проекта 
		projects[project].files = null;
		makeProjectFile(project);
	}
	void removeFile(string project, string key){
		projects[project].files.remove(key);
		makeProjectFile(project);
	}
}