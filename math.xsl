<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<xsl:template match="mathml:math">
	<xsl:copy>
		<xsl:apply-templates mode="math" select="@* | * | text()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="mathml:math/@type" mode="math">
	<xsl:attribute name="display"><xsl:value-of select="."/></xsl:attribute>
</xsl:template>

<!--
	The LaTeX sources contain code like
		text$_1$
	i.e. a inline math "block" without base for the subscript.
	This cannot be expressed directly in MathML, since MathML's
	<msub> requires a base.
	Therefore, LXir translates it to <sub><math>...</math></sub>
-->
<xsl:template match="  sub[count(*) = 1 and ./mathml:math]
                     | sup[count(*) = 1 and ./mathml:math]">
	<xsl:copy>
		<xsl:apply-templates mode="math" select="@* | * | text()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="@* | * | text()" mode="math">
	<xsl:copy>
		<xsl:apply-templates mode="math" select="@* | * | text()"/>
	</xsl:copy>
</xsl:template>


</xsl:stylesheet>
