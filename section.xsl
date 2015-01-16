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
	
	<xsl:element name="{concat('h',1+@level)}">
		<a class="heading-link" href="{concat('#', @id)}">
			<span class="heading-position"><xsl:value-of select="@position"/></span>
			<span class="heading-name"><xsl:apply-templates select="$heading-node" mode="heading"/></span>
			<span class="heading-id">
				<xsl:text>[</xsl:text><xsl:value-of select="@id"/><xsl:text>]</xsl:text>
			</span>
		</a>
	</xsl:element>
</xsl:template>

<xsl:template name="generalized-section">
	<xsl:param name="heading-node"/>
	<xsl:param name="intern-template"/>
	
	<section id="{@id}" class="{concat('level', @level)}">
		<xsl:apply-templates select="@*[name() != 'level' and name() != 'position']"/>
		
		<header>
			<xsl:call-template name="heading">
				<xsl:with-param name="heading-node" select="$heading-node"/>
			</xsl:call-template>
		</header>
		
		<xsl:apply-templates select="." mode="section-intern"/>
	</section>
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


<!--
	The definitions in [intro.defs] are implemented using the subsection-counter
	in LaTeX.
	They're also within a (proper) section and each form a block of content,
	so I deem them quite similar to subsections.
-->
<xsl:template match="definition">
	<xsl:call-template name="generalized-section">
		<xsl:with-param name="heading-node" select="./defines"/>
		<xsl:with-param name="intern-template" select="'definition-intern'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="definition" mode="section-intern">
	<xsl:if test="alt-name">
		<div class="alt-name">
			<xsl:text>Also called:</xsl:text>
			<ul class="alt-name">
				<xsl:apply-templates select="alt-name"/>
			</ul>
		</div>
	</xsl:if>
	
	<xsl:apply-templates select="explanation"/>
	
	<xsl:apply-templates select="*[name() != 'alt-name' and name() != 'explanation'] | text()"/>
</xsl:template>

<xsl:template match="definition/defines"/>
<xsl:template match="definition/defines" mode="heading">
	<xsl:apply-templates select="* | text()"/>
</xsl:template>

<xsl:template match="definition/alt-name">
	<li>
		<xsl:apply-templates select="@* | * | text()"/>
	</li>
</xsl:template>

<xsl:template match="definition/explanation">
	<div class="explanation"><!-- todo: might be a <p>? -->
		<xsl:apply-templates select="@* | * | text()"/>
	</div>
</xsl:template>

<xsl:template match="definition/explanation/br">
	<xsl:copy/>
</xsl:template>


</xsl:stylesheet>
