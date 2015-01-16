<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<!-- some tools that deal with the 'number' attribute -->


<xsl:template name="make-id-with">
	<xsl:param name="number"/>
	
	<xsl:attribute name="id">
		<xsl:value-of select="concat(ancestor::*[@id][1]/@id, '/', $number)"/>
	</xsl:attribute>
</xsl:template>

<xsl:template name="make-id">
	<xsl:call-template name="make-id-with">
		<xsl:with-param name="number" select="@number"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="make-enum-id">
	<xsl:call-template name="make-id-with">
		<xsl:with-param name="number"
		                select="concat(ancestor::par/@number,
		                               '.', 1 + count(preceding-sibling::item))"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="make-number">
	<xsl:param name="class"/>
	<xsl:variable name="is-li" select="name(.) = 'item'"/>
	
	<a class="{$class}" href="{concat('#', ancestor::*[@id][1]/@id, '/', @number)}">
		<xsl:if test="$is-li"><xsl:text>(</xsl:text></xsl:if>
		<xsl:value-of select="@number"/>
		<xsl:if test="$is-li"><xsl:text>)</xsl:text></xsl:if>
		<xsl:text> </xsl:text><!-- the space allows better text copying and display w/o CSS -->
	</a>
</xsl:template>


</xsl:stylesheet>
