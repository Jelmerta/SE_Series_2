module CloneDataTypes

data FileLineIndex = fileLineIndex(str filePath, int line);

data Duplication = duplication(str filePath, list[int] lines, list[str] code, int amountOfLines);

// Note that amount of lines and ast depth may be different for different duplications in the same clone class.
// For type 1 and 2 clone classes, tree size will be the same. The amount of lines may still be different, but an approximation on the clone class level is probably more helpful.
data CloneClass = cloneClass(str cloneClassName, int amountOfDuplications, int treeSize, list[Duplication] duplications); // Each clone class contains two or more duplications

data CloneReport = cloneReport(int amountOfDuplicatedLines,
							   int amountOfCodeLinesInProject,
							   real percentageDuplicatedLines,
							   int numberOfClones,
							   int numberOfCloneClasses,
							   Duplication biggestClone,
							   CloneClass biggestCloneClass,
							   list[CloneClass] exampleClones);