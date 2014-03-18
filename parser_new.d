import std.stdio;
import std.stdint;
import std.regex;
import std.string;
import std.algorithm;
import std.conv;
import std.range;

enum LexemType {_another, _comment, _number, _word, _symbol, _string, _bracket, _default = -1};
string[] TypeName = ["another", "comment", "number", "word", "symbol", "string", "bracket"];

struct Lexeme
{
	int begin;
	int end;
	LexemType type;
}

struct Function
{
	string[] arguments;
	string nextPositionName;
};

struct Position
{
	Function[] functions;
	LexemType exitValue = LexemType._default;
};

LexemType getType(string textType)
{
	for(LexemType i = LexemType._another; i <= LexemType._bracket; ++i)
	{
		if(textType == TypeName[i])
			return i;
	}
	return LexemType._default;
}

Position[string] readFunctions(string fileName)
{
	Position[string] positionSet;
	
	auto file = File(fileName);
	Position pos;
	string positionName;
	while(!file.eof())
	{	
		auto line = strip(file.readln());
		final switch(line[0])
		{
		case '#':
		{
			auto wline = split(line[1..$], regex(r"[:]"));
			pos.exitValue = getType(wline[1]);
			positionName = wline[0];
			positionSet[positionName] = pos;
			writeln(line,'\t',wline[0], '\t', wline[1], '\t', getType(wline[1]));
			break;
		}
		case '$':
		{
			auto wline = split(line[1..$],regex(r"[:]"));
			Function func;
			
			auto arguments = split(wline[0],regex(r"[\(\),]"));
			func.nextPositionName = wline[1];
			func.arguments = arguments[1..$-1];
			
			positionSet[positionName].functions ~= func;
			writeln(line,'\t',wline[0],':',arguments , '\t', wline[1]);
			break;
		}
		}
	}
	foreach(elem; positionSet)
	{
		writeln(elem);
	}
	return positionSet;
}

string readData(string fileName)
{
	auto file = File(fileName);
	string data = strip(file.readln());;
	return data;
}

int main()
{	
	//auto data = to!(char[])(readData("test.txt"));
	//writeln(data);
	auto positionsSet=readFunctions("functions.func");
	/*string currentPosition = "1";
	for(int i = 0; i < data.length && currentPosition != "end"; )
	{
		auto workFunction = positionsSet[currentPosition].currentFunctions[data[i]];
		if(workFunction.symbol != '_')
			data[i] = workFunction.symbol;
		i += workFunction.step;
		currentPosition = workFunction.nextPosition;
	}
	writeln(data);*/
	return 0;
}