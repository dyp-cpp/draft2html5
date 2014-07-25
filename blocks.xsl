<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<!-- minipages are used to display content side-by-side in columns -->
<xsl:template match="minipage-block">
	<div class="minipage-block">
		<xsl:apply-templates select="@* | * | text()"/>
	</div>
</xsl:template>

<xsl:template match="minipage-block/minipage">
	<div class="minipage">
		<xsl:apply-templates select="*"/>
	</div>
</xsl:template>


<xsl:template match="indented">
	<div class="indented">
		<xsl:apply-templates select="@* | * | text()"/>
	</div>
</xsl:template>


<xsl:template match="codeblock">
	<!-- for google prettify -->
	<xsl:comment>language: lang-cpp</xsl:comment>
	
	<pre class="prettyprint">
		<code class="block">
			<xsl:apply-templates select="@* | * | text()"/>
		</code>
	</pre>
</xsl:template>


</xsl:stylesheet>
