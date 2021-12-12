module Config

// Projects
private loc hsql = |project://hsqldb-2.3.1|;
private loc smallSql = |project://smallsql0.21_src|;

public loc PROJECT = smallSql;
public loc OUTPUT = |project://clones.txt|;

public int MIN_TREE_MASS = 5;
public int MIN_LINE_AMOUNT = 4;
public int AMOUNT_OF_EXAMPLES = 5;