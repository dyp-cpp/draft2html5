<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<xsl:template match="list">
	<xsl:choose>
		<xsl:when test="@type = 'enumerate'">
			<ol><xsl:apply-templates select="*"/></ol>
		</xsl:when>
		
		<xsl:when test="@type = 'itemize'">
			<ul><xsl:apply-templates select="*"/></ul>
		</xsl:when>
		
		<xsl:when test="@type = 'description'">
			<dl><xsl:apply-templates select="*"/></dl>
		</xsl:when>
		
		<xsl:otherwise>
			<div class="error">
				<xsl:text>[error]</xsl:text>
				<br/>
				<xsl:text>unknown or no list type: [</xsl:text>
				<xsl:value-of select="@type"/>
				<xsl:text>]</xsl:text>
				<ul><xsl:apply-templates select="*"/></ul>
			</div>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="list[@type = 'enumerate' or @type = 'itemize']/item">
	<li>
		<xsl:choose>
			<xsl:when test="../@type = 'enumerate'">
				<xsl:call-template name="make-enum-id"/>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:call-template name="make-id"/>
				
				<xsl:call-template name="make-number">
					<xsl:with-param name="class" select="'li-number'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="itemMark">
			<xsl:attribute name="class">custom-itemMark</xsl:attribute>
		</xsl:if>
		
		<xsl:apply-templates select="@* | * | text()"/>
	</li>
</xsl:template>

<xsl:template match="list[@type = 'description']/item">
	<dt><xsl:apply-templates select="@* | itemMark/@* | itemMark/* | itemMark/text()"/></dt>
	<dd><xsl:apply-templates select="itemMark/following-sibling::*"/></dd>
</xsl:template>

<xsl:template match="list/item/itemMark">
	<span class="itemMark"><xsl:apply-templates select="@* | * | text()"/></span>
</xsl:template>

<xsl:template match="list/item/@no-itemMark[. = 'true']">
	<xsl:attribute name="class">no-itemMark</xsl:attribute>
</xsl:template>

<!--
	The description lists in [cpp.predefined] originally had manual
	line breaks after the item names.
	This is some kind of backwards-compatibility feature (deprecated).
-->
<xsl:template match="list[@type = 'description']/item/br[name(preceding-sibling::*) = 'itemMark']"/>


</xsl:stylesheet>
