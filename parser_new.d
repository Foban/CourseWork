import std.stdio;
import std.stdint;
import std.string;
import std.algorithm;
import std.conv;
import std.range;
import std.regex;
import std.file;

enum LexemType {_another, _comment, _number, _word, _symbol, _string, _bracket_open, _bracket_close, _default = -1};
string[] TypeName = ["another", "comment", "number", "word", "symbol", "string", "bracket_open", "bracket_close"];

struct Lexeme
{
	int begin;
	int end;
	LexemType type;
}

struct Function
{
	string arguments;
	string nextPositionName;
};

struct Position
{
	Function[] functions;
	LexemType exitValue = LexemType._default;
};

LexemType getType(string textType)
{
	for(LexemType i = LexemType._another; i <= LexemType._bracket_close; ++i)
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
		if(line != null)
			switch(line[0])
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
			
				func.nextPositionName = wline[1];
				func.arguments = wline[0][1..$-1];
			
				positionSet[positionName].functions ~= func;
				break;
			}
			default: break;
			}
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
	//auto data = (readData("parser.d"));
	auto data = readText("parser.d");
	//writeln(data);
	auto positionsSet = readFunctions("functions.func");
	string positionName = "begin";
	auto currentPosition = positionsSet[positionName];
	for(int i = 0; i < data.length; ++i)
	{
		foreach(func; currentPosition.functions)
		{
			if(!match(to!(string)(data[i]), regex(func.arguments)).empty)
			{
				positionName = func.nextPositionName;
				writeln(currentPosition.exitValue, " ", positionName);
				currentPosition = positionsSet[positionName];
				break;
			}
		}
		/*if(workFunction.symbol != '_')
			data[i] = workFunction.symbol;
		i += workFunction.step;
		positionName = workFunction.nextPosition;*/
	}
	writeln(data);
	return 0;
}