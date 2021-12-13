module CloneClassConverter

import lang::java::jdt::m3::Core;
import Prelude;
import Node;
import Set;

import CloneDataTypes;
import LineUtil;

list[CloneClass] convertToCloneClasses(map[node, set[node]] astCloneClasses, M3 m3) {
	map[FileLineIndex, str] locModel = buildLocModel(m3);
	return [convertToCloneClass(cloneClass, astCloneClasses[cloneClass], locModel) | node cloneClass <- astCloneClasses];
}

// Builds a clone class containing several metrics
CloneClass convertToCloneClass(node astCloneClass, set[node] duplications, map[FileLineIndex, str] locModel) {
	str cloneClassName = toString(astCloneClass);
	int amountOfDuplications = size(duplications);
	// An assumption is made that the depth of the ast of different clones is the same, which should be the case for type 1/2 clones
	// Making it random introduces nondeterminism, but this is not great either as the metrics will actually change depending on which duplication is chosen.
	node exampleDuplicationNode = toList(duplications)[0];//getOneFrom(duplications);

	int treeSize = findTreeSize(exampleDuplicationNode);
	
	list[Duplication] duplicationsInClass = convertDuplications(duplications, locModel);
	
	return cloneClass(cloneClassName, amountOfDuplications, treeSize, duplicationsInClass);
}

int calculateAmountOfLinesInNode(node n) {
	int amountOfLines;
	if (loc source := n.src) { // To cast the src from a value to a location, we match it using an expression, as also explained here: https://stackoverflow.com/questions/42650305/how-to-cast-data-of-type-value-to-other-type-of-values-in-rascal
		amountOfLines = source.end.line - source.begin.line + 1;
	}
	
	return amountOfLines;
}

list[Duplication] convertDuplications(set[node] duplicationsAst, map[FileLineIndex, str] locModel) {
	list[Duplication] duplications = [];
	for (node duplicationAst <- duplicationsAst) {
		if (loc source := duplicationAst.src) { // Used to convert value to src
			list[int] codeLineIndices = toIndices(source, locModel);
			list[str] codeLines = toCode(source.path, codeLineIndices, locModel);
			duplications += duplication(source.path, codeLineIndices, codeLines, size(codeLines));
		}
	}
	return duplications;
}

list[int] toIndices(loc source, map[FileLineIndex, str] locModel) {
	int lineFrom = source.begin.line-1;
	int lineTo = source.end.line-1;
	
	list[int] codeLineIndices = [];
	for (int lineIndex <- [lineFrom..lineTo+1]) {
		FileLineIndex fileLineIndex = fileLineIndex(source.path, lineIndex);
		if (locModel[fileLineIndex]?) {
			codeLineIndices += lineIndex;
		}
	}
	return codeLineIndices;
}

list[str] toCode(str filePath, list[int] lineIndices, map[FileLineIndex, str] locModel) {
	list[str] codeLines = [];
	for (int lineIndex <- lineIndices) {
		FileLineIndex fileLineIndex = fileLineIndex(filePath, lineIndex);
		codeLines += locModel[fileLineIndex];
	}
	return codeLines;
}

FileLineIndex toIndex(loc source, int line) {
	return fileLineIndex(source.path, line);
}

int findTreeSize(node tree) {
	return (0 | it + 1 | /node n <- tree);
}