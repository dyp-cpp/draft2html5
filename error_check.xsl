<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<xsl:template match="@*">
	<!-- todo: attributes not cleaned up yet -->
	<!--<xsl:attribute name="error">unknown attribute: <xsl:value-of select="name()"/></xsl:attribute>-->
</xsl:template>

<xsl:template match="*">
	<div class="error">
		<xsl:text>[error]</xsl:text>
		<br/>
		
		<xsl:text>unknown element: [</xsl:text>
			<xsl:value-of select="name()"/>
		<xsl:text>]</xsl:text>
		<br/>
		
		<xsl:text>content:</xsl:text>
		<br/>
		
		<div class="error-content">
			<xsl:apply-templates select="@* | * | text()"/>
		</div>
	</div>
</xsl:template>


</xsl:stylesheet>
