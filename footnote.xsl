<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<!-- todo: doesn't support multiple calls to the same footnote? -->
<xsl:template match="footnoteCall">
	<xsl:variable name="idref" select="@idref"/>
	<cxx-footnote>
		<xsl:apply-templates select="/document/footnotelist/footnote[@id = $idref]/footnoteText/*"/>
	</cxx-footnote>
</xsl:template>

<xsl:template match="footnoteText">
	<xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="footnotelist"/>


</xsl:stylesheet>
