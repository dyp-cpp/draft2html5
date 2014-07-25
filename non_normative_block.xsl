<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<xsl:template name="non-normative-block">
	<xsl:param name="intro"/>
	<xsl:param name="outro"/>
	<xsl:param name="class"/>
	
	<!-- cannot be a span as it may contain lists, for example -->
	<div class="{$class}">
		<xsl:apply-templates select="@*"/>
		<xsl:text>[</xsl:text>
		
		<span class="non-normative-intro"><xsl:value-of select="$intro"/></span>
		
		<xsl:apply-templates select="*"/>
		
		<span class="non-normative-outro">
			<xsl:text disable-output-escaping="yes"><![CDATA[&mdash;]]></xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
			<xsl:value-of select="$outro"/>
		</span>
		
		<xsl:text>]</xsl:text>
	</div>
</xsl:template>	

<xsl:template match="note">
	<xsl:call-template name="non-normative-block">
		<xsl:with-param name="intro" select="'Note: '"/>
		<xsl:with-param name="outro" select="'end note'"/>
		<xsl:with-param name="class" select="'note'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="example">
	<xsl:call-template name="non-normative-block">
		<xsl:with-param name="intro" select="'Example: '"/>
		<xsl:with-param name="outro" select="'end example'"/>
		<xsl:with-param name="class" select="'example'"/>
	</xsl:call-template>
</xsl:template>


</xsl:stylesheet>
