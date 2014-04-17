import std.string;

class ProjectException : Exception
{
	this(string error)
	{
		super(error);
	}
}