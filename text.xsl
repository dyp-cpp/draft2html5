<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<xsl:template match="text" name="text-element">
	<xsl:apply-templates select="@* | * | text()"/>
</xsl:template>

<xsl:template match="text()"><xsl:copy/></xsl:template>


</xsl:stylesheet>
