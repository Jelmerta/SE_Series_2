module LineUtil

import lang::java::jdt::m3::Core;
import IO;
import String;

import LineUtil;
import Prelude;
import CloneDataTypes;

map[FileLineIndex fileLineIndex, str code] buildLocModel(M3 m3) {
	map[FileLineIndex, str] locModel = ();
	for (file <- files(m3)) {
		list[str] linesInFile = getLinesInFile(file);
	
		codeLines = [];
		multilineComment = false;
		
		// Trims lines of files and makes sure comments are removed.
		int lineIndex = 0;
		for (str line <- linesInFile) {
			str trimmedLine = trim(line);
			if (startsWith(trimmedLine, "/*") && endsWith(trimmedLine, "*/")) {
			;
			} else if (startsWith(trimmedLine, "/*")) {
				multilineComment = true;
			} else if (endsWith(trimmedLine, "*/")) { 
				multilineComment = false;
			} else if (!(trimmedLine == "") && !isComment(trimmedLine) && !multilineComment) {
				FileLineIndex fileLineIndex = fileLineIndex(file.path, lineIndex);
				locModel[fileLineIndex] = trimmedLine;
			}
			lineIndex+=1;
		}	
	}
	return locModel;
}

int findAmountOfCodeLinesInProject(M3 m3) {
	return size(buildLocModel(m3));
}

list[str] getLinesInFile(loc file) {
	return readFileLines(file);
}

bool isComment(str line) {
    switch(line) {
    	// Single line comment
		case /^\s*\/\/\s*\w*/:
			return true;
		default:
			return false;		
	}
}
