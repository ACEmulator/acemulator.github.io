<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">

<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0 Strict//EN" encoding="UTF-8"/>

<!-- Generate the type TOC. -->
<xsl:template match="datatypes">
	<xsl:result-document href="./frameTypeTOC.html" method="html">
	<html>
	<head>
	<title>AC Protocol version <xsl:value-of select="/schema/revision/@version"/></title>
	<link type="text/css" rel="stylesheet" href="Classic.css"/>
	</head>
	
    <body>
	<table cellspacing="0" cellpadding="0" class="TOC">
		<tr>
			<td class="TOCHead">
				<p class="TOCHead">Struct types</p>
			</td>
		</tr>
	
		<xsl:for-each select="types/type[count(.//member) != 0]">
			<xsl:sort select="@name"/>
			<xsl:call-template name="GenTOCType">
				<xsl:with-param name="typedef" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	</table>

	<table cellspacing="0" cellpadding="0" class="TOC">
		<tr>
			<td class="TOCHead">
				<p class="TOCHead">Enum types</p>
			</td>
		</tr>
	
		<xsl:for-each select="enums/enum[value]">
			<xsl:sort select="@name"/>
			<xsl:call-template name="GenTOCEnum">
				<xsl:with-param name="typedef" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	</table>
	
	<table cellspacing="0" cellpadding="0" class="TOC">
		<tr>
			<td class="TOCHead">
				<p class="TOCHead">Mask types</p>
			</td>
		</tr>
	
		<xsl:for-each select="enums/enum[mask]">
			<xsl:sort select="@name"/>
			<xsl:call-template name="GenTOCEnum">
				<xsl:with-param name="typedef" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	</table>
	
	</body></html>
	</xsl:result-document>
</xsl:template>

<!-- Generate the TOC entry for one type. -->
<xsl:template name="GenTOCType">
  <xsl:param name="typedef"/>
	
	<tr>
		<td class="TOCEntry">
			<p class="TOC1">
			<xsl:call-template name="GenLink">
				<xsl:with-param name="frame">frameType</xsl:with-param>
				<xsl:with-param name="type" select="$typedef/@name"/>
				<xsl:with-param name="text"><b><xsl:value-of select="$typedef/@name"/></b></xsl:with-param>
			</xsl:call-template>
			</p>
		</td>
	</tr>
	
</xsl:template>
  
  <!-- Generate the TOC entry for one type. -->
<xsl:template name="GenTOCEnum">
  <xsl:param name="typedef"/>
	
	<tr>
		<td class="TOCEntry">
			<p class="TOC1">
			<xsl:call-template name="GenLink">
				<xsl:with-param name="frame">frameEnum</xsl:with-param>
				<xsl:with-param name="type" select="$typedef/@name"/>
				<xsl:with-param name="text"><b><xsl:value-of select="$typedef/@name"/></b></xsl:with-param>
			</xsl:call-template>
			</p>
		</td>
	</tr>
	
</xsl:template>

<xsl:template name="GenLink">
  <xsl:param name="frame"/>
  <xsl:param name="type"/>
  <xsl:param name="case"/>
  <xsl:param name="text"/>
	
	<a>
		<xsl:attribute name="target">
      <xsl:choose>
			<xsl:when test="$frame = 'frameEnum'">frameType</xsl:when>
			<xsl:otherwise><xsl:value-of select="$frame"/></xsl:otherwise>
	  </xsl:choose>
    </xsl:attribute>
		<xsl:attribute name="href">
		<xsl:choose>
		  <xsl:when test="$frame = 'frameType'">Types/</xsl:when>
		  <xsl:when test="$frame = 'frameEnum'">Types/</xsl:when>
		  <xsl:otherwise>Messages/</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$type"/>
		<xsl:text>.html</xsl:text></xsl:attribute>
		<xsl:copy-of select="$text"/>
  </a>
</xsl:template>

</xsl:stylesheet>
