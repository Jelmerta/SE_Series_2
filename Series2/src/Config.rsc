module Config

// Projects
private loc hsql = |project://hsqldb-2.3.1|;
private loc smallSql = |project://smallsql0.21_src|;

public loc PROJECT = smallSql;
public loc OUTPUT = |home:///clones.json|;

public int MIN_TREE_MASS = 5;
public int MIN_LINE_AMOUNT = 4;
public int AMOUNT_OF_EXAMPLES = 5;

data CloneType = cloneType(str name);
public CloneType cloneType = cloneType("Type2"); // Rascal does not seem to have enums, value for clone type should be "Type1" or "Type2".