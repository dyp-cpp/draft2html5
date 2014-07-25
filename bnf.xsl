<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<xsl:template match="bnf | bnftab">
	<!--
		Definition lists (dl) require a defined term (dt)
		However, not all bnfs define something explicitly
		inside the bnf (but in the surrounding text).
		For those, we use a ul instead of a dl.
	-->
	<xsl:choose>
		<xsl:when test="count(defines/*) > 0">
			<dl class="{@type}">
				<xsl:apply-templates select="@* | * | text()"/>
			</dl>
		</xsl:when>
		
		<xsl:otherwise>
			<ul class="{@type}">
				<xsl:apply-templates select="@* | * | text()"/>
			</ul>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="bnf/defines | bnftab/defines | bnfkeywordtab/defines">
	<xsl:if test="*">
		<dt><xsl:apply-templates select="@* | * | text()"/></dt>
	</xsl:if>
</xsl:template>

<xsl:template match="defines/nontermdef | defines/description | grammar-rule/description">
	<span class="{name()}"><xsl:apply-templates select="@* | * | text()"/></span>
</xsl:template>

<xsl:template match="bnf/grammar-rule | bnftab/grammar-rule">
	<!-- see the template that matches bnf | bnftab -->
	<xsl:choose>
		<xsl:when test="../defines/*">
			<dd><xsl:apply-templates select="@* | * | text()"/></dd>
		</xsl:when>
		
		<xsl:otherwise>
			<li><xsl:apply-templates select="@* | * | text()"/></li>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="bnftab/grammar-rule/br-hint">
	<xsl:element name="br"/>
</xsl:template>

<xsl:template match="bnftab//indent">
	<span class="indent"><xsl:text> </xsl:text></span>
</xsl:template>


<xsl:template match="bnfkeywordtab">
	<!--
		bnfkeywordtab environments are used if a nonterminal is defined
		via a large set of short rules (such as keywords)
		The XML contains the line break hints defined in LaTeX;
		we use those to form a table for better alignment.
		It's not really tabular data, though.
	-->
	<dl class="{name()}">
		<xsl:apply-templates select="defines"/>
		<dd><table><tbody>
			<xsl:apply-templates select="line-hint"/>
		</tbody></table></dd>
	</dl>
</xsl:template>

<xsl:template match="bnfkeywordtab/line-hint">
	<tr>
		<xsl:apply-templates select="@* | * | text()"/>
	</tr>
</xsl:template>

<xsl:template match="bnfkeywordtab/line-hint/keyword">
	<td>
		<code class="keyword"><xsl:apply-templates select="@* | * | text()"/></code>
	</td>
</xsl:template>


</xsl:stylesheet>
