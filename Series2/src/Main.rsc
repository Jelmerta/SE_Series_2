module Main

import IO;
import lang::java::jdt::m3::Core;
import util::Benchmark;
import util::Math;

import CloneDetector;
import CloneClassConverter;
import CloneDataTypes;
import CloneJsonWriter;
import CloneReportProducer;
import Config;

void main() {
	println("Software evolution - Assignment: Series 2");
	println("");
	println("Date: 2021-12-19");
	println("Authors: 12766992 & 10655751");
	println("");
	 	 
	runCloneDuplications(PROJECT, OUTPUT);
}

void runCloneDuplications(loc project, loc outputPath) {
 	M3 m3 = createM3FromEclipseProject(project);
 	
	int timeBefore = realTime();
	
	list[CloneClass] cloneClasses = findClones(m3);
	
	cloneClasses = filterByTreeMass(cloneClasses, MIN_TREE_MASS);
	cloneClasses = filterByLineAmount(cloneClasses, MIN_LINE_AMOUNT);
	
	writeCloneClassesToFile(outputPath, cloneClasses); 
	CloneReportProducer::produceCloneReport(m3, cloneClasses);
	
	int timeAfter = realTime();
	int executionTime = (timeAfter - timeBefore) / 1000;
	println("It took " + toString(executionTime) + " seconds to find the duplications.");
}

// Filters on clone classes placed here so unit tests can make use of findClones without setting configuration. Can be moved if unit tests can set configuration.
list[CloneClass] filterByTreeMass(list[CloneClass] cloneClasses, int minTreeMass) {
	return [cloneClass | cloneClass <- cloneClasses, cloneClass.treeSize >= minTreeMass];
}

list[CloneClass] filterByLineAmount(list[CloneClass] cloneClasses, int minLineAmount) {
	// Assumption is made: duplications have approximately the same amount of lines
	// We noticed at least one place (with an @Override) where this is not true.
	return [cloneClass | cloneClass <- cloneClasses, cloneClass.duplications[0].amountOfLines >= minLineAmount];
}