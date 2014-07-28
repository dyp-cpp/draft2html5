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
			
			<script src="bower_components/platform/platform.js"><xsl:comment> </xsl:comment></script>
			<link rel="import" href="bower_components/cxx-html-doc-framework/framework.html"/>
		</head>
		
		<body>
			<!-- error check -->
			<xsl:attribute name="onload">
<![CDATA[
document.querySelectorAll('*').array().forEach(
	function(node) {
		if (node.checkInvariants) node.checkInvariants();
	}
);
]]>
			</xsl:attribute>
			
			<!-- I forgot why this must not be empty :( -->
			<cxx-toc><xsl:comment> </xsl:comment></cxx-toc>
			
			<xsl:apply-templates/>
		</body>
	</html>
</xsl:template>


<!-- contains named templates, needs to be included first -->
<xsl:include href="number.xsl"/>

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
