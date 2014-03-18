import std.stdio;
import std.process;
import std.string;
import std.stdint;
import std.container;

import poject;
import help_function;


class ProjectManager
{
public:
	this(){}
	this(string projectFile)
	{
		if(exists(projectFile))
			projects[projectFile] = new Project(projectFile);
	}
	
	bool addProject(string projectFile)
	{
		if(exists(projectFile) && projectFile !in projects)
			projects[projectFile] = new Project(projectFile);		
	}
	
	bool addNewProject(string projectDirectory, string projectName)
	{
		if(exists(projectFile) && projectFile !in projects)
			projects[projectFile] = new Project(string projectDirectory, string projectName);	
	}
	
	void removeProject(string key)
	{
		projects.remove(key);
	}
	
	void clearManager()
	{
		projects = null;
	}
	
	string[string] getProjectsNames()
	{
		string[string] projectsNames;
		foreach(project; projects)
		{
			projectsNames[project.getName()] = project.getName();
		}
		return projectsNames;
	}
	
	ref Project getProject(string key)
	{
		return projects[key];
	}
	
private:
	Project[string] projects;
}