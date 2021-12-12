module CloneDetector

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import Prelude;
import Node;
import Set;
import Map;

import CloneDataTypes;
import CloneClassConverter;

// For Type 1 clone detection, we want to make sure that exact matches are found.
// We want to make sure that the largest node size is found (subsumption):
// In the case of a whole method matching for example, we want the whole method to be a match, but not anything within the function to be matches.
// So in that case there is only one match, which is the method.

// Similarly for type 2 detection, we want to verify the same thing, except it does not matter if types/names do not match.
list[CloneClass] findClones(loc projectPath) {
	M3 m3 = createM3FromEclipseProject(projectPath);

	map[node, set[node]] cloneClassesAst = findAstClones(projectPath, m3);
	return CloneClassConverter::convertToCloneClasses(cloneClassesAst, m3);
}

map[node, set[node]] findAstClones(loc projectPath, M3 m3) {
	list[Declaration] asts = getASTs(m3);
	map[node, node] srcNodeToNormalizedNodeMap = buildSrcNodeToNormalizedNodeMap(asts);
	map[node, set[node]] possibleCodeClones = invert(srcNodeToNormalizedNodeMap);
	map[node, set[node]] codeClasses = filterDuplicates(possibleCodeClones);
	map[node, set[node]] codeClonesWithoutSubsumptions = removeSubsumptions(codeClasses);
	return codeClonesWithoutSubsumptions;
}

list[Declaration] getASTs(M3 m3) {
	return [createAstFromFile(containment[0], true) | containment <- m3.containment, containment[0].scheme == "java+compilationUnit"];
}

map[node, node] buildSrcNodeToNormalizedNodeMap(list[Declaration] asts) {
	// Apparently, not all nodes have a source: This seems to be the case for the following types: simpleType, arrayType, infix.
	// simpleType and arrayType do not seem to matter much as it is followed by a simpleName, which has a source and does not lose further information.
	// Infix however, does _sometimes_ lose some information, for example in string concatenations ("test" + "123") would not be found as a separate clone.
	// As we would really like to have the source available on nodes to provide further metrics on, we have chosen to filter out nodes without sources.
	
	// unsetRec is used to remove source from the node.
	// The descendant operator is used for a deep match, instead of using the visit pattern.
	return (srcNode : unsetRec(srcNode) | /node srcNode <- asts, srcNode.src?); 
}

map[node, set[node]] filterDuplicates(map[node, set[node]] codeClasses) {
	return (codeClassNode : codeClasses[codeClassNode] | codeClassNode <- codeClasses, size(codeClasses[codeClassNode]) > 1);
}

// To make sure that a clone class is subsumed, we have to make sure that all the sources of node classes are part of a subtree of another clone class.
// 1. Build subtrees without parent node of sources (as a match on the parent node would be a match for the same clone class) 
// 2. For each clone class, make sure that all sources in clone class are in subtrees to be subsumed
// 3. If the clone class is not subsumed (strictly contained), keep it, otherwise drop it.
map[node, set[node]] removeSubsumptions(map[node cloneClass, set[node] sources] cloneClasses) {	
	set[node] childNodes = findAllChildNodes(union(cloneClasses.sources));
	return (cloneClassNode : cloneClasses[cloneClassNode] | cloneClassNode <- cloneClasses.cloneClass, !(cloneClasses[cloneClassNode] < childNodes));
}

set[node] findAllChildNodes(set[node] parentNodes) {
	return union(buildSubtrees(parentNodes));
}

set[set[node]] buildSubtrees(set[node] cloneClasses) {
	return mapper(cloneClasses, buildSubtree);
}

set[node] buildSubtree(node parent) {
	// The descendant operator is used for a deep match, instead of using the visit pattern.
	return {subtreeNode | /node subtreeNode <- parent} - parent; // Only contains child nodes, not the parent 
}