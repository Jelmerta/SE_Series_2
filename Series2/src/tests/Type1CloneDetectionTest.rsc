module tests::Type1CloneDetectionTest

import lang::java::jdt::m3::Core;
import List;

import CloneDetector;
import CloneClassConverter;
import CloneDataTypes;

// Before running type 1 tests, make sure to set the config file right! Sadly we do not yet have a possibility to set the config in the unit test.

test bool testTypeOne() {
	loc duplicationSameLineSixTimes = |project://CodeDuplicationTestOneBlock|;
	M3 m3 = createM3FromEclipseProject(duplicationSameLineSixTimes);
	
	int expectedAmountOfCodeClasses = 1;
	int expectedAmountOfDuplications = 6;
	
	list[CloneClass] cloneClasses = findClones(m3);
	
	 expectedAmountOfCodeClasses == size(cloneClasses);
	list[Duplication] duplications = cloneClasses[0].duplications;
	assert expectedAmountOfDuplications == size(duplications);
	
	return true; // All asserts succeeded, so we can just return true...
}

test bool testSubsumption() {
	loc duplicationsWithSubsumptions = |project://ClonesWithSubsumption|;
	M3 m3 = createM3FromEclipseProject(duplicationsWithSubsumptions);
	
	int expectedAmountOfCodeClasses = 2;
	int expectedAmountOfDuplications = 2;
	
	list[CloneClass] cloneClasses = findClones(m3);
	assert expectedAmountOfCodeClasses == size(cloneClasses);
	list[Duplication] duplications = cloneClasses[0].duplications;
	assert expectedAmountOfDuplications == size(duplications);
	duplications = cloneClasses[1].duplications;
	assert expectedAmountOfDuplications == size(duplications);
	
	return true; // All asserts succeeded, so we can just return true...
}

test bool testSubsumptionOneNotSubsumed() {
	loc duplicationsWithSubsumptionsNotInClone = |project://ClonesWithSubsumptionNotInClone|;
	M3 m3 = createM3FromEclipseProject(duplicationsWithSubsumptionsNotInClone);
	
	int expectedAmountOfCodeClasses = 3;
	set[int] expectedAmountOfDuplications = {2,5}; // Not the greatest test as we check multiple amount of duplications (we want to match 2-2-5 in any order, but this matches more). Still gives us good confidence.
	set[int] foundAmountOfDuplications = {};
	
	list[CloneClass] cloneClasses = findClones(m3);
	assert expectedAmountOfCodeClasses == size(cloneClasses);
	
	list[Duplication] duplications = cloneClasses[0].duplications;
	foundAmountOfDuplications += size(duplications);
	duplications = cloneClasses[1].duplications;
	foundAmountOfDuplications += size(duplications);
	duplications = cloneClasses[2].duplications;
	foundAmountOfDuplications += size(duplications); 	
	
	assert expectedAmountOfDuplications == foundAmountOfDuplications;
	
	return true; // All asserts succeeded, so we can just return true...
}
