<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<xsl:template match="note">
	<cxx-note>
		<xsl:apply-templates select="*"/>
	</cxx-note>
</xsl:template>

<xsl:template match="example">
	<cxx-example>
		<xsl:apply-templates select="*"/>
	</cxx-example>
</xsl:template>


</xsl:stylesheet>
