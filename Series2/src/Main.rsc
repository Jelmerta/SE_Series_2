module Main

import IO;
import lang::java::jdt::m3::Core;
import util::Benchmark;
import util::Math;
import List;

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
	println("Amount of clone classes found: " + toString(size(cloneClasses)));
	writeCloneClassesToFile(outputPath, cloneClasses); 
	CloneReportProducer::produceCloneReport(m3, cloneClasses);
	
	int timeAfter = realTime();
	int executionTime = (timeAfter - timeBefore) / 1000;
	println("It took " + toString(executionTime) + " seconds to find the duplications.");
}