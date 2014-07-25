<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<xsl:template match="figure">
	<xsl:copy>
		<xsl:apply-templates select="@* | * | text()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="figure/caption">
	<figcaption>
		<xsl:value-of select="../@position"/>
		<xsl:text> - </xsl:text>
		<xsl:apply-templates select="@* | * | text()"/>
	</figcaption>
</xsl:template>


<!--
	Import of graphics is not supported yet.
	They typically consist of DOT files (i.e. graphs) that would need
	to be converted/compiled to a format that can be displayed in HTML.
	In any case, it's probable that any graphics imported into the
	original LaTeX sources is not directly compatible or fit for web
	usage.
-->
<xsl:template match="importgraphic">
	<xsl:apply-templates select="@*"/>
	<div style="width: 90%; border: solid 1px black; display: block; margin: 1em auto 1em auto; text-align: center; padding: 1em 0 1em 0;">
		<xsl:text>placeholder for </xsl:text>
		<xsl:value-of select="."/>
	</div>
</xsl:template>


</xsl:stylesheet>
