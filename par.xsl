<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<xsl:template match="par[@number]">
	<!--
		As much as I'd like to use <p> for numbered paragraphs,
		it would not produce valid HTML:
		A numbered paragraph cannot contain grouping content
		such as lists.
	-->
	<div class="numbered-paragraph">
		<xsl:call-template name="make-id"/>
		
		<xsl:call-template name="make-number">
			<xsl:with-param name="class" select="'par-number'"/>
		</xsl:call-template>
		
		<xsl:apply-templates select="*"/>
	</div>
</xsl:template>

<!-- some sections have introductory paragraphs such as a bnf in [expr.prim.general]
	 which have no numbers but can reasonably be seen as paragraphs (structurally) -->
<xsl:template match="par[ not(@number) and name(ancestor::*[1]) = 'section'
						  and name(preceding-sibling::*[1]) = 'title'       ]">
	<div class="numbered-paragraph">
		<xsl:apply-templates select="@* | * | text()"/>
	</div>
</xsl:template>

<xsl:template match="par[not(@number) and ancestor::footnotelist]">
	<div class="footnote-par">
		<xsl:apply-templates select="@* | * | text()"/>
	</div>
</xsl:template>


</xsl:stylesheet>
