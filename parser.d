import std.stdio;
import std.process;
import std.string;
import std.stdint;
import std.file;
import std.algorithm;
import std.regex;

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
					"short","long", "double"];

class Parser
{
	public:
	void test(){}
	void parse(string text)
	{
		auto lines = splitLines(text);
		foreach(i,line;lines)
		{
			//writeln(i+1,'\t',line);
			//regex("[ \t,.;:?{}'\"\a()]+")
			auto wline = split(strip(line),regex(r"[\[ \t\]]")).filter!(a => a!="");
			foreach(word; wline)
			{
				if(typesTest(word))
					writeln(i+1,'.',' ',word);
			}
		}
		foreach(i,line;lines)
		{
			//writeln(i+1,'\t',line);
			//regex("[ \t,.;:?{}'\"\a()]+")
			auto wline = split(strip(line),regex(r"[\[ \t\]]")).filter!(a => a!="");
			foreach(word; wline)
			{
				if(keywordsTest(word))
					writeln(i+1,'.',' ',word);
			}
		}
	}
	
	bool _;
	 
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
}

int main()
{
	string text = readText("project.d");
	Parser p = new Parser;
	p.parse(text);
	return 0;
}