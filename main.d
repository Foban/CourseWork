import std.stdio;
import std.process;
import std.string;
import std.stdint;

import project;
import help_function;

//dmd -w -release -ofDebug\IDE help_function.d main.d project.d

void menu()
{
	writeln("1) Add file");
	//writeln("1) Add new file");
	writeln("2) All files");
	//writeln("1) Build project");
	writeln("3) Start project");
	writeln("4) Delete file");
	writeln("5) Delete all files");
	//writeln("1) Save project");
	writeln("0) Close");
}

int main()
{
	clearConsole();
	int k;
	bool f = true;
	menu();
	auto manager = new Project;
	while(f){
		readf(" %s", &k);
		clearConsole();
		switch(k)
		{
		case 1:
		{
			writeln("Input path to file:");
			string adds;
			readf(" \n", &adds);
			clearConsole();
			if(!manager.addFile(adds))
				writeln("Wrong path");
			break;
			}
		case 2:
			string path;
			auto files = manager.getFiles();
			foreach(file; files)
			{
				path ~= file ~ '\n';
			}
			writeln(path);
			break;
		case 3:
			manager.start();
			break;
		case 4:
			hello();
			break;
		case 5:
			manager.clear();
			break;
		case 0:
			f = false;
			break;
		default:
			writeln("\nError input\n");
			break;
		}
		menu();
	}
	clearConsole();
	writeln("Goodbye!! ;)\n");
	return 0;
}
