# Clone Detection Tool

## What it does

This tool can be used to detect clones of java code using several clone type detection algorithms. It does this through an AST algorithm.
When run, it provides a metric report with several data points, such as the amount of duplicated code lines, the amount of clone classes found, the biggest clone and example clones.
It also writes the clones to a file in a json format. An example is provided in section Clone Detection Output.

## Instructions

Please make sure that the project to be examined is added in this project, as otherwise this tool cannot run.

Several configuration settings can be set when running this tool.
The configuration settings are found in the project in this file: src/Config.rsc.

Several example project locations are first mentioned in the configuration, such as smallsql and hsql.
Next, we need to actually choose the project we wish to examine using the following line:
public loc PROJECT = smallSql;

We can also set the output path. By default the clones are written to a file in the home directory.
public loc OUTPUT = |home:///clones.json|;

Next we have two filters for the found clones. We are usually not interested in very small clones, as the code clones may be even smaller than one line.
The MIN_TREE_AMOUNT filters out AST trees that have a smaller size than a certain amount. It is fine to keep this at 1 if we instead use the MIN_LINE_AMOUNT to filter:
public int MIN_TREE_MASS = 1;
The MIN_LINE_AMOUNT only keeps track of clones that have a certain line amount. Code clones that are less than 3 lines long will for example be filtered out if we set this variable to 4 or higher.
public int MIN_LINE_AMOUNT = 6;

Several examples are written to the terminal in the metric report. If we want to change the amount of examples shown that can be done using this value.
public int AMOUNT_OF_EXAMPLES = 5;

Last we have the type of clones that can be detected using this program.
data CloneType = cloneType(str name);
There are currently 3 configurations possible:
- "Type1": Type 1 clone detection, this will find exact matches of code in the project.
- "Type2": Type 2 clone detection, this will find matches that are syntactically somewhat similar: Method, type and variable identifiers will be normalized.
- "JustRemoveAllIdentifiers": clone detection where all identifiers are removed, this will find syntactically identical code: Names of variables, types, methods, classes, interfaces, constructors, imports, packages, among others, will be normalized. This could therefore even find classes that are syntactically identical.

## Clone Detection Output

The output of the clone detection tool is provided in a JSON format and contains several metrics for every clone class.

An example of one clone class  may look something like this (depending on configuration):

{
    "cloneClass": {
      "cloneClassName": "method(void(),\"\",[],[],block([expressionStatement(assignment(simpleName(\"\"),\"=\",number(\"0\"))),expressionStatement(assignment(simpleName(\"\"),\"=\",qualifiedName(simpleName(\"\"),simpleName(\"\"))))]))",
      "amountOfDuplications": 2,
      "treeSize": 20,
      "duplications": [
        {
          "duplication": {
            "filePath": "/src/smallsql/database/TableResult.java",
            "lines": [
              325,
              326,
              327,
              328,
              329
            ],
            "code": [
              "@Override",
              "final void noRow(){",
              "row = 0;",
              "store = Store.NOROW;",
              "}"
            ],
            "amountOfLines": 5
          }
        },
        {
          "duplication": {
            "filePath": "/src/smallsql/database/TableResult.java",
            "lines": [
              318,
              319,
              320,
              321,
              322
            ],
            "code": [
              "@Override",
              "final void nullRow(){",
              "row = 0;",
              "store = Store.NULL;",
              "}"
            ],
            "amountOfLines": 5
          }
        }
      ]
    }
  }


