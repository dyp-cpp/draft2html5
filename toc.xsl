<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<!--
	Requires: a variable named "toc-maxlevel", containing an integer.
	This variable defines the maximum section level displayed in the ToC.
	For example, a maximum level of 2 will include chapters, sections
	and subsections.
-->


<xsl:template match="/" mode="toc">
	<ul>
		<xsl:apply-templates mode="toc" select="*"/>
	</ul>
</xsl:template>

<xsl:template name="generalized-section-toc">
	<xsl:param name="heading-node"/>
	
	<xsl:variable name="class" select="concat('level', @level)"/>
	<li class="{$class}">
		<a class="toc" href="{concat('#', @id)}">
			<xsl:value-of select="@position"/>
			<xsl:text> </xsl:text>
			<xsl:apply-templates mode="toc-heading" select="$heading-node"/>
		</a>
		
		<xsl:if test="@level &lt; $toc-maxlevel">
			<ul class="{$class}">
				<!--
					If the <ul> does not contain any elements, XSLT can/does merge
					the start and end tag <ul></ul> to a self-closing tag <ul/>
					However, self-closing <ul/> are invalid HTML and lead to
					display problems.
					By inserting a comment, we try to keep separate start and end
					tags.
				-->
				<xsl:comment> </xsl:comment>
				
				<xsl:apply-templates select="*" mode="toc"/>
			</ul>
		</xsl:if>
	</li>
</xsl:template>


<xsl:template match="section" mode="toc">
	<xsl:call-template name="generalized-section-toc">
		<xsl:with-param name="heading-node" select="title"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="section/title" mode="toc-heading">
	<xsl:apply-templates/>
</xsl:template>


<!-- As in the content (non-ToC) part, we treat definitions as subsections -->
<xsl:template match="definition" mode="toc">
	<xsl:call-template name="generalized-section-toc">
		<xsl:with-param name="heading-node" select="./defines"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="definition/defines" mode="toc-heading">
	<xsl:apply-templates/>
</xsl:template>

	
<xsl:template match="*" mode="toc">
	<xsl:apply-templates mode="toc" select="*"/>
</xsl:template>


</xsl:stylesheet>
