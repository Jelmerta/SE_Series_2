module tests::Type2CloneDetectionTest

import lang::java::jdt::m3::Core;
import List;

import CloneDetector;
import CloneClassConverter;
import CloneDataTypes;

// Before running type 2 tests, make sure to set the config file right! Sadly we do not yet have a possibility to set the config in the unit test.

test bool testTypeTwoMethods() {
	loc project = |project://Type2FunctionIdentifier|;
	M3 m3 = createM3FromEclipseProject(project);
	
	int expectedAmountOfCodeClasses = 1;
	int expectedAmountOfDuplications = 2;
	int expectedLineAmount = 4;
	
	list[CloneClass] cloneClasses = findClones(m3);
 	expectedAmountOfCodeClasses == size(cloneClasses);
	list[Duplication] duplications = cloneClasses[0].duplications;
	assert expectedAmountOfDuplications == size(duplications);
	
	Duplication firstDuplication = duplications[0];
	assert expectedLineAmount == size(firstDuplication.lines);
	
	return true; // All asserts succeeded, so we can just return true...
}

test bool testTypeTwoMethodsWithVariables() {
	loc project = |project://Type2VariableIdentifierMethod|;
	M3 m3 = createM3FromEclipseProject(project);
	
	int expectedAmountOfCodeClasses = 1;
	int expectedAmountOfDuplications = 2;
	int expectedLineAmount = 3;
	
	list[CloneClass] cloneClasses = findClones(m3);
	
 	expectedAmountOfCodeClasses == size(cloneClasses);
	list[Duplication] duplications = cloneClasses[0].duplications;
	assert expectedAmountOfDuplications == size(duplications);
	
	Duplication firstDuplication = duplications[0];
	assert expectedLineAmount == size(firstDuplication.lines);
	
	return true; // All asserts succeeded, so we can just return true...
}

test bool testTypeTwoClassesWithState() {
	loc project = |project://Type2VariableIdentifierState|;
	M3 m3 = createM3FromEclipseProject(project);
	
	int expectedAmountOfCodeClasses = 1;
	int expectedAmountOfDuplications = 2;
	int expectedLineAmount = 1;
	
	list[CloneClass] cloneClasses = findClones(m3);
	
 	expectedAmountOfCodeClasses == size(cloneClasses);
	list[Duplication] duplications = cloneClasses[0].duplications;
	assert expectedAmountOfDuplications == size(duplications);
	
	Duplication firstDuplication = duplications[0];
	assert expectedLineAmount == size(firstDuplication.lines);
	
	return true; // All asserts succeeded, so we can just return true...
}

test bool testTypeTwoTypeIdentifier() {
	loc project = |project://Type2TypeIdentifier|;
	M3 m3 = createM3FromEclipseProject(project);
	
	int expectedAmountOfCodeClasses = 1;
	int expectedAmountOfDuplications = 2;
	int expectedLineAmount = 4;
	
	list[CloneClass] cloneClasses = findClones(m3);
	
 	expectedAmountOfCodeClasses == size(cloneClasses);
	list[Duplication] duplications = cloneClasses[0].duplications;
	assert expectedAmountOfDuplications == size(duplications);
	
	Duplication firstDuplication = duplications[0];
	assert expectedLineAmount == size(firstDuplication.lines);
	
	return true; // All asserts succeeded, so we can just return true...
}

test bool testTypeTwoTypeIdentifierReturn() {
	loc project = |project://Type2TypeIdentifierReturn|;
	M3 m3 = createM3FromEclipseProject(project);
	
	int expectedAmountOfCodeClasses = 1;
	int expectedAmountOfDuplications = 2;
	int expectedLineAmount = 5;
	
	list[CloneClass] cloneClasses = findClones(m3);
	
 	expectedAmountOfCodeClasses == size(cloneClasses);
	list[Duplication] duplications = cloneClasses[0].duplications;
	assert expectedAmountOfDuplications == size(duplications);
	
	Duplication firstDuplication = duplications[0];
	assert expectedLineAmount == size(firstDuplication.lines);
	
	return true; // All asserts succeeded, so we can just return true...
}