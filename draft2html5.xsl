<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">
	<!--xmlns="http://www.w3.org/1999/xhtml"-->


<!-- settings -->
<xsl:variable name="toc-maxlevel" select="1"/>
<xsl:variable name="enable-prettify" select="false()"/>


<!-- XSLT-compatible HTML5 DTD -->
<xsl:output method="xml" indent="yes" encoding="UTF-8"
			doctype-system="about:legacy-compat"
			omit-xml-declaration="yes"/>


<xsl:strip-space elements="*"/>
<xsl:preserve-space elements="text"/>


<xsl:template match="/document">
	<html>
		<head>
			<meta charset="utf-8"/>
			
			<title>A C++ draft formatting test</title>
			
			<xsl:if test="$enable-prettify">
				<script src="https://google-code-prettify.googlecode.com/svn/loader/run_prettify.js?lang=Cpp">
				</script>
			</xsl:if>
			
			<link rel="stylesheet" type="text/css" href="cpp-draft.css"/>
		</head>
		
		<body>
			<nav id="toc">
				<header><h1>Table of contents</h1></header>
				<xsl:apply-templates mode="toc" select="/"/>
			</nav>
			
			<!-- even though it's not really article-like,
				 I think the structuring implied by this element makes sense here -->
			<article id="main">
				<xsl:apply-templates/>
			</article>
		</body>
	</html>
</xsl:template>


<!-- contains named templates, needs to be included first -->
<xsl:include href="number.xsl"/>

<xsl:include href="toc.xsl"/>
<xsl:include href="section.xsl"/>
<xsl:include href="par.xsl"/>
<xsl:include href="blocks.xsl"/>
<xsl:include href="non_normative_block.xsl"/>
<xsl:include href="figure.xsl"/>
<xsl:include href="bnf.xsl"/>
<xsl:include href="list.xsl"/>	
<xsl:include href="table.xsl"/>	
<xsl:include href="inline.xsl"/>
<xsl:include href="math.xsl"/>
<xsl:include href="footnote.xsl"/>
<xsl:include href="text.xsl"/>

<xsl:include href="error_check.xsl"/>


</xsl:stylesheet>
