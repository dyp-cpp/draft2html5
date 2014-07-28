<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">
	<!--xmlns="http://www.w3.org/1999/xhtml"-->


<xsl:template name="heading">
	<xsl:param name="heading-node"/>
	
	<h1>
		<xsl:apply-templates select="$heading-node" mode="heading"/>
	</h1>
</xsl:template>

<xsl:template name="generalized-section">
	<xsl:param name="heading-node"/>
	<xsl:param name="intern-template"/>
	
	<xsl:choose>
		<xsl:when test="@level = 0">
			<cxx-clause id="{@id}">
				<xsl:call-template name="heading">
					<xsl:with-param name="heading-node" select="$heading-node"/>
				</xsl:call-template>
				
				<xsl:apply-templates select="." mode="section-intern"/>
			</cxx-clause>
		</xsl:when>
		
		<xsl:otherwise>
			<cxx-section id="{@id}">
				<xsl:call-template name="heading">
					<xsl:with-param name="heading-node" select="$heading-node"/>
				</xsl:call-template>
				
				<xsl:apply-templates select="." mode="section-intern"/>
			</cxx-section>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="section">
	<xsl:call-template name="generalized-section">
		<xsl:with-param name="heading-node" select="title"/>
		<xsl:with-param name="intern-template" select="'section-intern'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="section" mode="section-intern">
	<xsl:apply-templates select="*"/>
</xsl:template>

<!-- the title is added within the template for section -->
<xsl:template match="section/title"/>
<xsl:template match="section/title" mode="heading">
	<xsl:apply-templates select="* | text()"/>
</xsl:template>


<xsl:template match="definition">
	<dl is="cxx-definition-section">
		<xsl:apply-templates select="*"/>
	</dl>
</xsl:template>

<xsl:template match="definition" mode="section-intern">
	<xsl:apply-templates select="alt-name"/>
	
	<xsl:apply-templates select="explanation"/>
	
	<xsl:apply-templates select="*[name() != 'alt-name' and name() != 'explanation'] | text()"/>
</xsl:template>

<xsl:template match="definition/defines">
	<dt id="{../@id}">
		<xsl:apply-templates select="@* | * | text()"/>
	</dt>
</xsl:template>

<xsl:template match="definition/alt-name">
	<dt>
		<xsl:apply-templates select="@* | * | text()"/>
	</dt>
</xsl:template>

<xsl:template match="definition/explanation">
	<dd>
		<xsl:apply-templates select="@* | * | text()"/>
	</dd>
</xsl:template>

<xsl:template match="definition/explanation/br">
	<xsl:copy/>
</xsl:template>


</xsl:stylesheet>
