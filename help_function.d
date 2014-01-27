import std.stdio;
import std.process;
import std.string;
import std.stdint;

void hello()
{
	writeln("I regret to inform you that this feature is not available in the trial version of the program.\n");
}

void clearConsole()
{
	version(Windows)
	{
		system("cls");
	}
	else version(linux)
	{
		system("clear");
	}
}