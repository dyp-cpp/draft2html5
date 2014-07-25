<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<xsl:template match="footnoteCall">
	<a>
		<xsl:attribute name="href">
			<xsl:value-of select="concat('#', ./@idref)"/>
		</xsl:attribute>
		<xsl:attribute name="class">footnoteMark</xsl:attribute>
		
		<xsl:apply-templates select="@* | *"/>
	</a>
</xsl:template>

<xsl:template match="footnoteCall/@idref"/>

<xsl:template match="footnoteCall/footnoteMark">
	<xsl:apply-templates select="@* | * | text()"/>
</xsl:template>


<xsl:template match="footnotelist">
	<section class="footnotelist">
		<header><h1>Footnotes</h1></header>
		<xsl:apply-templates select="@* | * | text()"/>
	</section>
</xsl:template>

<xsl:template match="footnote">
	<div class="footnote"><!-- a footnote can contain multiple paragraphs -->
		<xsl:apply-templates select="@*"/>
		
		<div class="footnote-intro"><!-- same problem as above -->
			<xsl:apply-templates select="footnoteMark"/>
			<xsl:apply-templates select="footnoteBackref"/>
		</div>
		
		<xsl:apply-templates select="footnoteText"/>
	</div>
</xsl:template>

<xsl:template match="footnote/footnoteMark">
	<span class="footnoteMark"><xsl:apply-templates select="@* | * | text()"/></span>
</xsl:template>

<xsl:template match="footnoteBackref">
	<a href="{concat('#', @idref)}" class="footnoteBackref">^</a>
</xsl:template>

<xsl:template match="footnoteText">
	<div class="footnoteText"><xsl:apply-templates select="@* | * | text()"/></div>
</xsl:template>


</xsl:stylesheet>
