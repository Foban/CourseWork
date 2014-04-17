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
import core.thread;
import std.utf;

enum LexemType {_another, _comment, _number, _word, _symbol, _string, _bracket, _bracket_open, _bracket_close, _default, _reservedTypes, _keywords, _point};
string[] TypeName = ["another", "comment", "number", "word", "symbol", "string", "bracket", "bracket_open", "bracket_close", "default", "reservedTypes", "keywords", "point"];

auto keywords = ["abstract", "else", "macro", "switch",
				"alias", "enum", "mixin", "synchronized",
				"align", "export", "module", "asm", "extern",
				"template", "assert", "new", "this", "auto",
				"false", "nothrow", "throw", "final", "null",
				"true", "body", "finally", "try", 
				"out", "typeid", "break", "for" ,"override", "typeof",
				 "foreach", "function", "package", 
				"case", "pragma", "cast", "goto", "private",
				"ulong", "catch", "protected", "union",  "ifIf",
				"public", "unittest", "class", "immutable", "pure",
				"continue", "in",  "version", "inout", "ref", 
				 "return", "debug", "interface",
				"default", "invariant", "scope", "while", "delegate", "isIs",
				"with", "deprecated", "static", "do", "struct",
				"lazy", "super", "const", "import"];
auto reservedTypes = ["bool", "float","byte","ubyte","uint","char",
					"ushort","real","void", "dchar", "int", "wchar",
					"short","long", "double","string","wstring","dstring"];
					
					

struct Lexeme
{
	int begin;
	int end;
	LexemType type = LexemType._default;;
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

bool keywordsTest(string word)
{
	foreach(elem; keywords)
	{
		if(elem == word)
			
			return true;
	}
	return false;
}

bool typesTest(string word)
{
	foreach(elem; reservedTypes)
	{
		if(elem == word)
				
			return true;
	}
	return false;
}

LexemType defineType(string word)
{
	if(keywordsTest(word)) return LexemType._keywords;
	if(typesTest(word)) return LexemType._reservedTypes;
	return LexemType._word;
}


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
				break;
			}
			case '$':
			{
				auto wline = split(line[2..$],regex(r"[)][:]"));
				Function func;
			
				func.nextPositionName = wline[1];
				func.arguments = wline[0];
				positionSet[positionName].functions ~= func;
				break;
			}
			default: break;
			}
	}
	return positionSet;
}

/*string readData(string fileName)
{
	auto file = File(fileName);
	string data = strip(file.readln());
	return data;
}*/

Lexeme[] parse(string data)
{	
	auto positionsSet = readFunctions("functions.func");
	string positionName = "begin";
	auto currentPosition = positionsSet[positionName];
	
	Lexeme token;
	Lexeme[] ListOfLexemes;
	SList!(Lexeme*) CurlyBracketsStack;
	SList!(Lexeme*) ParenthesesStack;
	SList!(Lexeme*) BracesStack;
	int i = 0;
	int k = 0;
	int ibegin=0;
	int m;
	for(; i < data.length; i+=m, ++k)
	{
		if(positionName == "begin"){
			token.begin = k;
			ibegin = i;
		}
		bool flag  = true;  
		m=std.utf.stride(data,i);
		
		foreach(func; currentPosition.functions)
		{	
			if(!match(data[i..m+i], func.arguments).empty)
			{
				positionName = func.nextPositionName;				
				flag = false;
				break;
			}
		}
		if(flag && positionName != "begin") //флаг поднят(true) идем по алгоритму сначала, если не поднят(false) продолжаем
		{
			token.end = k; 
			if(currentPosition.exitValue == LexemType._word)
				token.type = defineType(data[ibegin..i]);
			else
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
			ListOfLexemes~=token;
			--i;
			--k;
		}
		currentPosition = positionsSet[positionName];
	}
	if(positionName != "begin")
	{
		//switch(data[i])
		token.end = k; 
		if(currentPosition.exitValue == LexemType._word)
				token.type = defineType(data[ibegin..i]);
			else
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
		ListOfLexemes ~= token;
	}
	/*foreach(elem; ListOfLexemes)
		writeln(elem);*/
	return ListOfLexemes;
}