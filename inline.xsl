<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<xsl:template match="ref">
	<cxx-ref to="@idref"/>
</xsl:template>

<xsl:template match="@id | @idref">
	<xsl:copy/>
</xsl:template>


<xsl:template match="ICS">
	<math class="ICS">
		<msub>
			<mtext>ICS</mtext>
			<mi><xsl:value-of select="@index"/></mi>
		</msub>
		<mo>(</mo>
		<mtext>
			<code class="inline"><xsl:value-of select="@arg"/></code>
		</mtext>
		<mo>)</mo>
	</math>
</xsl:template>


<xsl:template match="cpp">
	<xsl:text>C++</xsl:text><!-- might need a space like uniquens -->
</xsl:template>

<xsl:template match="opt">
	<span class="opt">opt</span>
</xsl:template>

<xsl:template match="uniquens">
	<!-- the space isn't perfect, but helps -->
	<span class="uniquens"><xsl:text>unique </xsl:text></span>
</xsl:template>

<xsl:template match="cvqual">
	<span class="cvqual"><xsl:apply-templates select="@* | * | text()"/></span>
</xsl:template>

<xsl:template match="tcode | terminal">
	<code class="inline"> <!-- could pretty-print that too, but I don't think it's worth it -->
		<xsl:apply-templates select="@* | * | text()"/>
	</code>
</xsl:template>

<xsl:template match="emph">
	<em><xsl:apply-templates select="@* | * | text()"/></em>
</xsl:template>

<xsl:template match="logop | NTS | term">
	<span class="{name()}"><xsl:apply-templates select="@* | * | text()"/></span>
</xsl:template>

<xsl:template match="doccite">
	<cite class="doccite"><xsl:apply-templates select="@* | * | text()"/></cite>
</xsl:template>

<xsl:template match="placeholder | numconst">
	<var class="{name()}"><xsl:apply-templates select="@* | * | text()"/></var>
</xsl:template>

<xsl:template match="grammarterm | nonterminal">
	<cxx-term class="{name()}"><xsl:apply-templates select="@* | * | text()"/></cxx-term>
</xsl:template>

<xsl:template match="defnx">
	<dfn class="defnx"><xsl:apply-templates select="@* | * | text()"/></dfn>
</xsl:template>


</xsl:stylesheet>
