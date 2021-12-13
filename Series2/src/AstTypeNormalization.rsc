module AstTypeNormalization

import lang::java::jdt::m3::AST;
import lang::java::m3::AST;

import Config;

list[Declaration] normalizeAstForType(list[Declaration] asts) {
	if (cloneType.name == "Type1") {
		return asts;
	} else if (cloneType.name == "Type2") {
		return normalizeType2(asts);
	} else {
		throw "Not a valid clone type";
	}
}
	
// Definition from https://link.springer.com/content/pdf/10.1007%2F978-3-540-76440-3.pdf:
// • Type 2 is a syntactically identical copy; only variable, type, or function identifiers have been changed.
list[Declaration] normalizeType2(list[Declaration] asts) {
	list[Declaration] normalizedAsts = [];
	for (Declaration ast <- asts) {
		normalizedAsts += normalizeType2(ast);
	}
	return normalizedAsts;
}

Declaration normalizeType2(Declaration ast) {
	Type normalizedType = \void();
	str normalizedName = "";

	return visit (ast) {
		case Type _ => normalizedType
		case \type(_) => \type(normalizedType)
		
		case \method(returnType, _, parameters, exceptions, impl) => \method(returnType, normalizedName, parameters, exceptions, impl)
		//case \method(returnType, _, parameters, exceptions) => \method(returnType, normalizedName, parameters, exceptions) // Does not work... Not sure why.
		case \variable(_, extraDimensions) => \variable(normalizedName, extraDimensions)
		case \variable(_, extraDimensions, initializer) => \variable(normalizedName, extraDimensions, initializer)
		
		// Are these needed? Probably not: Actually changes logic...?
		//case \simpleName(_) => \simpleName(normalizedName)
		//case \stringLiteral(_) => \stringLiteral(normalizedName)
		// Method call seems logical as we also have the normalization for methods? But that is not specifically a method identifier, so we will not add this.
		
		// Parameter? typeParameter? Seems unnecessary as method parameters are already matched.
	};
}