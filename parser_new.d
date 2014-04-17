import std.stdio;
import std.stdint;
import std.string;
import std.algorithm;
import std.conv;
import std.range;
import std.regex;
import std.file;
import std.container;
import std.datetime;

enum LexemType {_another, _comment, _number, _word, _symbol, _string, _bracket, _bracket_open, _bracket_close, _default};
string[] TypeName = ["another", "comment", "number", "word", "symbol", "string", "bracket", "bracket_open", "bracket_close", "default"];

struct Lexeme
{
	int begin;
	int end;
	LexemType type = LexemType._default;;
}

struct Function//(T)
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
	for(LexemType i = LexemType._another; i <= LexemType._default; ++i)
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
				auto wline = split(line[2..$],regex(r"[)][:]"));
				Function func;
			
				func.nextPositionName = wline[1];
				func.arguments = wline[0];
				writeln(wline[0]);
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
	//auto data = readText("test.d");
	//auto data = readText("parser.d");
	auto data = readText("template.c");
	//writeln(data);
	auto b = stdTime();
	auto positionsSet = readFunctions("functions.func");
	string positionName = "begin";
	auto currentPosition = positionsSet[positionName];
	Lexeme token;
	/*DList!Lexeme ListOfLexemes;
	SList!(Lexeme*) CurlyBracketsStack;
	SList!(Lexeme*) ParenthesesStack;
	SList!(Lexeme*) BracesStack;*/
	int i = 0;
	for(; i < data.length; ++i)
	{
		if(positionName == "begin")
			token.begin = i;
		bool flag  = true;  
		foreach(func; currentPosition.functions)
		{
			if(!match(to!(string)(data[i]), func.arguments).empty)
			{
				positionName = func.nextPositionName;
				//writeln(currentPosition.exitValue, " ", positionName);
				
				flag = false;
				break;
			}
		}
		if(flag && positionName != "begin") //флаг поднят(true) идем по алгоритму сначала, если не поднят(false) продолжаем
		{
			--i;
			token.end = i; 
			token.type = currentPosition.exitValue;
			positionName = "begin";
			/*switch(positionsSet[positionName].exitValue)
				{
					case LexemType._bracket_open:
					{
						ListOfLexemes.stableInsertBack(token);
						final switch(data[i])
						{
							case '{':
								CurlyBracketsStack.stableInsertFront(&(ListOfLexemes.back()));
								break;
							case '(':
								ParenthesesStack.stableInsertFront(&(ListOfLexemes.back()));
							break;
							case '[':
								BracesStack.stableInsertFront(&(ListOfLexemes.back()));
							break;
						}
						break;
					}
					case LexemType._bracket_close:
					{
						final switch(data[i])
						{
							case '}':
							{
								if(!CurlyBracketsStack.empty)
								{
									writeln(*(CurlyBracketsStack.front()));
									(*(CurlyBracketsStack.front())).end = i;
									(*(CurlyBracketsStack.front())).type = LexemType._bracket;
									writeln(*(CurlyBracketsStack.removeAny()));
								}
								break;
							}
							case ')':
								//ParenthesesStack.front(&token);
							break;
							case ']':
								//BracesStack.front(&token);
							break;
						}
						positionName = "begin";
						break;
					}
					default:
					{
						ListOfLexemes.stableInsertBack(token);
						break;
					}
				}*/
			ListOfLexemes.stableInsertBack(token);
			//writeln(token);
		}
		
		currentPosition = positionsSet[positionName];
	}
	if(positionName != "begin")
	{
		//switch(data[i])
		--i;
		token.end = i; 
		token.type = currentPosition.exitValue;
		positionName = "begin";
		/*switch(positionsSet[positionName].exitValue)
				{
					case LexemType._bracket_open:
					{
						ListOfLexemes.stableInsertBack(token);
						final switch(data[i])
						{
							case '{':
								CurlyBracketsStack.stableInsertFront((ListOfLexemes.back()));
								break;
							case '(':
								ParenthesesStack.stableInsertFront(&(ListOfLexemes.back()));
							break;
							case '[':
								BracesStack.stableInsertFront(&(ListOfLexemes.back()));
							break;
						}
						break;
					}
					case LexemType._bracket_close:
					{
						final switch(data[i])
						{
							case '}':
							{
								if(!CurlyBracketsStack.empty)
								{
									writeln(*(CurlyBracketsStack.front()));
									(*(CurlyBracketsStack.front())).end = i;
									(*(CurlyBracketsStack.front())).type = LexemType._bracket;
									writeln(*(CurlyBracketsStack.removeAny()));
								}
								break;
							}
							case ')':
								//ParenthesesStack.front(&token);
							break;
							case ']':
								//BracesStack.front(&token);
							break;
						}
						positionName = "begin";
						break;
					}
					default:
					{
						ListOfLexemes.stableInsertBack(token);
						break;
					}
				}*/
		ListOfLexemes.stableInsertBack(token);
		//writeln(token);
	}
	//writeln(ListOfLexemes.front());
	//writeln(ListOfLexemes.back());
	b -= stdTime();
	writeln(b);
	return 0;
}