module AstTypeNormalization

import lang::java::jdt::m3::AST;
import lang::java::m3::AST;

import Config;

node normalizeAstForType(node ast) {
	if (cloneType.name == "Type1") {
		return ast;
	} else if (cloneType.name == "Type2") {
		return normalizeType2(ast);
	} else if (cloneType.name == "JustRemoveAllIdentifiers") {
		return normalizeAllIdentifiers(ast);
	} else {
		throw "Not a valid clone type";
	}
}
	
list[node] normalizeType2(list[node] asts) {
	list[Declaration] normalizedAsts = [];
	for (Declaration ast <- asts) {
		normalizedAsts += normalizeType2(ast);
	}
	return normalizedAsts;
}

// Definition from https://link.springer.com/content/pdf/10.1007%2F978-3-540-76440-3.pdf:
// • Type 2 is a syntactically identical copy; only variable, type, or function identifiers have been changed.
// We have implemented this very exactly according to what identifier should be normalized in this definition.
// A separate implementation that removes all identifiers is shown after this type.
node normalizeType2(node ast) {
	Type normalizedType = \void();
	str normalizedName = "";

	return visit (ast) {
		case Type _ => normalizedType
		case \type(_) => \type(normalizedType)
		
		case \method(returnType, _, parameters, exceptions, impl) => \method(returnType, normalizedName, parameters, exceptions, impl)
		case \method(returnType, _, parameters, exceptions) => \method(returnType, normalizedName, parameters, exceptions)
		case \variable(_, extraDimensions) => \variable(normalizedName, extraDimensions)
		case \variable(_, extraDimensions, initializer) => \variable(normalizedName, extraDimensions, initializer)
	};
}

node normalizeAllIdentifiers(node ast) {
	Type normalizedType = \void();
	str normalizedName = "";

	return visit (ast) {
		case \enum(_, implements, constants, body) => \enum(normalizedName, implements, constants, body)
		case \enumConstant(_, arguments, class) => \enumConstant(normalizedName, arguments, class)
		case \enumConstant(_, arguments) => \enumConstant(normalizedName, arguments)
		case \class(_, extends, implements, body) => \class(normalizedName, extends, implements, body)
		case \interface(_, extends, implements, body) => \class(normalizedName, extends, implements, body)  
		case \method(returnType, _, parameters, exceptions, impl) => \method(returnType, normalizedName, parameters, exceptions, impl)
		case \method(returnType, _, parameters, exceptions) => \method(returnType, normalizedName, parameters, exceptions)
		case \constructor(_, parameters, exceptions, impl) => \constructor(normalizedName, parameters, exceptions, impl)
		case \import(_) => \import(normalizedName)
		case \package(_) => \package(normalizedName)
		case \package(declaration, _) => \package(declaration, normalizedName)
		case \typeParameter(_, extendsList) => \typeParameter(normalizedName, extendsList)
		case \annotationType(_, body) => \annotationType(normalizedName, body)
		case \annotationTypeMember(typeVar, _) => \annotationTypeMember(typeVar, normalizedName)
		case \annotationTypeMember(typeVar, _, defaultBlock) => \annotationTypeMember(typeVar, normalizedName, defaultBlock)
		case \parameter(typeVar, _, extraDimensions) => \parameter(typeVar, normalizedName, extraDimensions)
		case \vararg(typeVar, _) => \vararg(typeVar, normalizedName)
		
		case \fieldAccess(isSuper, expression, _) => \fieldAccess(isSuper, expression, normalizedName)
		case \fieldAccess(isSuper, _) => \fieldAccess(isSuper, normalizedName)
		case \methodCall(isSuper, _, arguments) => \methodCall(isSuper, normalizedName, arguments)
		case \methodCall(isSuper, receiver, _, arguments) => \methodCall(isSuper, receiver, normalizedName, arguments)
		case \variable(_, extraDimensions) => \variable(normalizedName, extraDimensions)
		case \variable(_, extraDimensions, initializer) => \variable(normalizedName, extraDimensions, initializer)
		case \simpleName(_) => \simpleName(normalizedName)
		case \markerAnnotation(_) => \markerAnnotation(normalizedName) // Typename?
		case \normalAnnotation(_, memberValuePairs) => \normalAnnotation(normalizedName, memberValuePairs) // Typename?
		case \memberValuePair(_, valueVar) => \memberValuePair(normalizedName, valueVar)
		case \singleMemberAnnotation(_, valueVar) => \singleMemberAnnotation(normalizedName, valueVar) // Typename?
		
		case \label(_, body) => \label(normalizedName, body)
		
		case Type _ => normalizedType
		case \type(_) => \type(normalizedType) // Used as an expression, and immediately goes to Type, probably not too relevant, but does not hurt either?
	};
}