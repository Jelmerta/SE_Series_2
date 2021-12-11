class ClonesWithSubsumption {
	// Both functions are also identically found in the other class.
	// The line "int i = 1;" is found 4 times in total, and is always subsumed by other clones and therefore should not be found.
	// We should find two clones with both 2 duplications.
    private void assignOne() {
    	int i = 1;
    }
    
    private void otherAssignOne() {
    	int i = 1;
    }
}