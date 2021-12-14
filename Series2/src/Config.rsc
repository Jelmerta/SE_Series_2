module Config

// Projects
private loc hsql = |project://hsqldb-2.3.1|;
private loc smallSql = |project://smallsql0.21_src|;
// Test projects
private loc type2Types = |project://Type2TypeIdentifier|;
private loc subsumptionNotInClone = |project://ClonesWithSubsumptionNotInClone|;
private loc subsumption = |project://ClonesWithSubsumption|;

public loc PROJECT = smallSql;
public loc OUTPUT = |home:///clones.json|;

public int MIN_TREE_MASS = 1;
public int MIN_LINE_AMOUNT = 6;
public int AMOUNT_OF_EXAMPLES = 5;

data CloneType = cloneType(str name);
public CloneType cloneType = cloneType("JustRemoveAllIdentifiers"); // Rascal does not seem to have enums, value for clone type should be "Type1" or "Type2" or "JustRemoveAllIdentifiers" (for a syntax check).