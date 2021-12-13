module CloneReportProducer

import lang::java::jdt::m3::Core;
import util::Math;
import IO;

import CloneDataTypes;
import LineUtil;
import List;
import Set;
import Config;

void produceCloneReport(M3 m3, list[CloneClass] cloneClasses) {
	int amountOfCodeLinesInProject = findAmountOfCodeLinesInProject(m3);
	int amountOfDuplicatedLines = calculateLinesDuplicatedForCloneClasses(cloneClasses);
	
	setPrecision(2);
	real percentageDuplicatedLines = toReal(amountOfDuplicatedLines) / amountOfCodeLinesInProject * 100;
	
	int numberOfClones = findNumberOfClones(cloneClasses);
	int numberOfCloneClasses = size(cloneClasses);
	Duplication biggestClone = findBiggestClone(cloneClasses);
	CloneClass biggestCloneClass = findBiggestCloneClass(cloneClasses);
	
	exampleClones = [];
	for (int _ <- [0..AMOUNT_OF_EXAMPLES]) {
		exampleClones += getOneFrom(cloneClasses);
	}
	
	CloneReport cloneReport = cloneReport(amountOfDuplicatedLines, amountOfCodeLinesInProject, percentageDuplicatedLines, numberOfClones, numberOfCloneClasses, biggestClone, biggestCloneClass, exampleClones);
	writeCloneReport(cloneReport);
}

int findNumberOfClones(list[CloneClass] cloneClasses) {
	return (0 | it + size(cloneClass.duplications) | CloneClass cloneClass <- cloneClasses);
}

Duplication findBiggestClone(list[CloneClass] cloneClasses) {
	Duplication biggestClone = cloneClasses[0].duplications[0];
	for (CloneClass cloneClass <- cloneClasses) {
		for (Duplication duplication <- cloneClass.duplications) {
			if (size(duplication.lines) > size(biggestClone.lines)) {
				biggestClone = duplication;
			}
		}
	}
	return biggestClone;
}

CloneClass findBiggestCloneClass(list[CloneClass] cloneClasses) {
	CloneClass biggestCloneClass = cloneClasses[0];
	for (CloneClass cloneClass <- cloneClasses) {
		if (cloneClass.amountOfDuplications > biggestCloneClass.amountOfDuplications) {
			biggestCloneClass = cloneClass;
		}
	}
	return biggestCloneClass;
}

int calculateLinesDuplicatedForCloneClasses(list[CloneClass] cloneClasses) {
	set[FileLineIndex] fileLineIndices = {};
	for (CloneClass cloneClass <- cloneClasses) {
		list[Duplication] duplications = cloneClass.duplications;
		for (Duplication duplication <- duplications) {
			for (int line <- duplication.lines) {
				FileLineIndex index = fileLineIndex(duplication.filePath, line);
				fileLineIndices += index;
			}
		}
	}
	return size(fileLineIndices);
}

void writeCloneReport(CloneReport cloneReport) {
	println("------------------------------------");
	println("----- CLONE DUPLICATION REPORT -----");
	println("------------------------------------\n");
	println();
	println("----- CONFIG -----");
	println("CHOSEN PROJECT: " + PROJECT.uri);
	println("USING CLONE TYPE: " + cloneType.name);
	println("MINIMUM AST TREE MASS: " + toString(MIN_TREE_MASS));
	println("MINIMUM AMOUNT OF LINES IN DUPLICATION: " + toString(MIN_LINE_AMOUNT));
	println();
	println("----- METRICS -----");
	println("DUPLICATED CODE LINES: " + toString(cloneReport.amountOfDuplicatedLines));
	println("TOTAL CODE LINES: " + toString(cloneReport.amountOfCodeLinesInProject));
	println("PERCENTAGE DUPLICATE CODE: " + toString(cloneReport.percentageDuplicatedLines));
	println();
	println("TOTAL NUMBER OF CLONE CLASSES: " + toString(cloneReport.numberOfCloneClasses));
	println("TOTAL NUMBER OF CLONES: " + toString(cloneReport.numberOfClones));
	println();
	println("BIGGEST CLONE WAS FOUND AT: " + cloneReport.biggestClone.filePath);
	println("ON LINES " + toString(cloneReport.biggestClone.lines[0]) + "-" + toString(last(cloneReport.biggestClone.lines)));
	println("THE CODE FOR THE BIGGEST CLONE: ");
	for (str line <- cloneReport.biggestClone.code) {
		println(line);
	}
	println();
	println("MOST FREQUENT OCURRING CLONE CLASS WITH " + toString(cloneReport.biggestCloneClass.amountOfDuplications) + " DUPLICATIONS:");
	list[str] biggestCloneCode = getOneFrom(cloneReport.biggestCloneClass.duplications).code;
	for (str line <- biggestCloneCode) {
		println(line);
	}
	println();
	println("EXAMPLE CLONES:");
	for (CloneClass exampleClone <- cloneReport.exampleClones) {
		list[str] exampleCloneCode = getOneFrom(exampleClone.duplications).code;
		for (str line <- exampleCloneCode) {
			println(line);
		}
		println();
	}
	println();
}