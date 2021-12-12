module tests::Type1CloneDetectionTest

import CloneDetector;
import CloneClassConverter;
import CloneDataTypes;

import List;

test bool testTypeOne() {
	loc duplicationSameLineSixTimes = |project://CodeDuplicationTestOneBlock|;
	
	int expectedAmountOfCodeClasses = 1;
	int expectedAmountOfDuplications = 6;
	
	list[CloneClass] cloneClasses = findClones(duplicationSameLineSixTimes);
	
	 expectedAmountOfCodeClasses == size(cloneClasses);
	list[Duplication] duplications = cloneClasses[0].duplications;
	assert expectedAmountOfDuplications == size(duplications);
	
	return true; // All asserts succeeded, so we can just return true...
}

test bool testSubsumption() {
	loc duplicationsWithSubsumptions = |project://ClonesWithSubsumption|;
	
	int expectedAmountOfCodeClasses = 2;
	int expectedAmountOfDuplications = 2;
	
	list[CloneClass] cloneClasses = findClones(duplicationsWithSubsumptions);
	assert expectedAmountOfCodeClasses == size(cloneClasses);
	list[Duplication] duplications = cloneClasses[0].duplications;
	assert expectedAmountOfDuplications == size(duplications);
	duplications = cloneClasses[1].duplications;
	assert expectedAmountOfDuplications == size(duplications);
	
	return true; // All asserts succeeded, so we can just return true...
}

test bool testSubsumptionOneNotSubsumed() {
	loc duplicationsWithSubsumptions = |project://ClonesWithSubsumptionNotInClone|;
	
	int expectedAmountOfCodeClasses = 3;
	set[int] expectedAmountOfDuplications = {2,5}; // Not the greatest test as we check multiple amount of duplications (we want to match 2-2-5 in any order, but this matches more). Still gives us good confidence.
	set[int] foundAmountOfDuplications = {};
	
	list[CloneClass] cloneClasses = findClones(duplicationsWithSubsumptions);
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
