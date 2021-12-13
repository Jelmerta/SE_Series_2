// Fun note: This project with type 2 actually gives us 1 clone with 5 duplications.
// This may explain why we get fewer clone classes for type 2.

class ClonesWithSubsumptionNotInClone {
	// Both functions are also identically found in the other class.
	// The line "int i = 1;" is found 5 times in total, 4 of them should be subsumed by other clones,
	// but as the fifth is not part of the clone classes, we should get 3 total clone classes.
	// 1 of the clone classes should be found in five locations.
    private void assignOne() {
    	int i = 1;
    }
    
    private void otherAssignOne() {
    	int i = 1;
    }
    
    private void notACloneClassFunction() {
    	int i = 1; // < This is a line that does match with other places, but the whole method does not match anything.
    }
}