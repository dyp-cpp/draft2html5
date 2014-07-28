<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lxir="http://www.latex-lxir.org"
	xmlns:mathml="http://www.w3.org/1998/Math/MathML"
	exclude-result-prefixes="lxir mathml">


<!--
	Support for tables is still incomplete.
	The XML representation of tables is unstable, i.e.
	likely to change in the future.
-->


<xsl:template match="table">
	<table id="{@id}" is="cxx-table">
		<xsl:apply-templates select="*"/>
	</table>
</xsl:template>

<xsl:template match="table/caption">
	<xsl:copy>
			<xsl:apply-templates select="@* | * | text()"/>
	</xsl:copy>
</xsl:template>
<!-- the continued caption is mainly a feature for visualizations with a limited page size -->
<xsl:template match="table/continued-caption"/>

<xsl:template match="table/tabular">
	<xsl:apply-templates select="*"/>
</xsl:template>

<!-- Not supported yet -->
<xsl:template match="table/tabular/columnsModel"/>

<xsl:template match="table/tabular/rowGroup">
	<xsl:apply-templates select="@* | * | text()"/>
</xsl:template>

<xsl:template match="table/tabular/rowGroup/tableHeader">
	<xsl:if test="not(@headType) or @headType != 'continued'">
		<thead>
			<xsl:apply-templates select="@* | * | text()"/>
		</thead>
	</xsl:if>
</xsl:template>

<xsl:template match="table/tabular/rowGroup/row | table/tabular/rowGroup/tableHeader/row">
	<tr>
		<xsl:apply-templates select="@* | * | text()"/>
	</tr>
</xsl:template>


<xsl:template match="row/cell | row/multicolumn/cell">
	<xsl:if test="not(@multirow-target)">
		<td>
			<xsl:if test="multirow">
				<xsl:attribute name="rowspan"><xsl:value-of select="multirow/@rows"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="name(..) = 'multicolumn'">
				<xsl:attribute name="colspan"><xsl:value-of select="../@columns"/></xsl:attribute>
			</xsl:if>
			
			<xsl:apply-templates select="*"/>
			
			<xsl:if test="not(*)">
				<!-- empty HTML table cells seem to require some content -->
				<!-- todo: do that correctly.. -->
				<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
			</xsl:if>
		</td>
	</xsl:if>
</xsl:template>

	<!-- support for multirow and multicolumn -->
	
	<xsl:template match="  table/tabular/rowGroup/row/cell/multirow
						 | table/tabular/rowGroup/tableHeader/row/cell/multirow">
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<xsl:template match="  table/tabular/rowGroup/row/multicolumn
	                     | table/tabular/rowGroup/tableHeader/row/multicolumn">
		<xsl:apply-templates select="*"/>
	</xsl:template>


</xsl:stylesheet>
