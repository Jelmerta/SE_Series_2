module CloneJsonWriter

import lang::json::IO;

import CloneDataTypes;

void writeCloneClassesToFile(loc filePath, list[CloneClass] cloneClasses) {			
	writeJSON(filePath, cloneClasses);
}