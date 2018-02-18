<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">

<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0 Strict//EN" encoding="UTF-8"/>

<!-- Generate the message TOC. -->
<xsl:template match="messages">
	<xsl:result-document href="./frameMsgTOC.html" method="html">
    <html>
	<head>
	<title>AC Protocol version <xsl:value-of select="/schema/revision/@version"/></title>
	<link type="text/css" rel="stylesheet" href="Classic.css"/>
	</head>
	
    <body>
	<table cellspacing="0" cellpadding="0" class="TOC">
		<tr>
			<td class="TOCHead">
				<p class="TOCHead">Messages</p>
			</td>
		</tr>
		
		<xsl:for-each select="message[not(@unknown)]">
			<xsl:call-template name="GenTOCMsg">
				<xsl:with-param name="message" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	</table>
	</body></html>
   </xsl:result-document>
</xsl:template>

<!-- Generate the TOC entry for one message. -->
<xsl:template name="GenTOCMsg">
  <xsl:param name="message"/>
	<tr>
		<td class="TOCEntry">
			<p>
	    <xsl:variable name="msgEnum" select="/schema/datatypes/enums/enum[@name = 'MessageType']" />
      <xsl:variable name="msgEnumEntry" select="$msgEnum/value[@value = $message/@type]"/>
			<xsl:attribute name="class"><xsl:choose>
			  <xsl:when test="$message/@retired">TOC1Retired</xsl:when>
			  <xsl:otherwise>TOC1</xsl:otherwise>
			  </xsl:choose></xsl:attribute>
			<xsl:call-template name="GenLink">
				<xsl:with-param name="frame">frameMsg</xsl:with-param>
				<xsl:with-param name="type" select="$message/@type"/>
				<xsl:with-param name="direction" select="$message/@direction"/>
				<xsl:with-param name="text"><b><xsl:value-of select="$message/@type"/>:</b><xsl:text> </xsl:text><xsl:value-of select="$msgEnumEntry/@name"/></xsl:with-param>
			</xsl:call-template>
       - <xsl:value-of select="$message/@direction"/> - <xsl:value-of select="$message/@queue"/>
			</p>
		</td>
	</tr>
	
</xsl:template>

<xsl:template name="GenLink">
  <xsl:param name="frame"/>
  <xsl:param name="type"/>
  <xsl:param name="case"/>
  <xsl:param name="text"/>
  <xsl:param name="direction"/>
	
	<a>
		<xsl:attribute name="target">
      <xsl:choose>
				<xsl:when test="$frame = 'frameEnum'">frameType</xsl:when>
				<xsl:otherwise><xsl:value-of select="$frame"/></xsl:otherwise>
				</xsl:choose>
    </xsl:attribute>
		<xsl:attribute name="href">
		<xsl:text>Messages/</xsl:text>
		<xsl:value-of select="$type"/>
		<xsl:text>-</xsl:text>
		<xsl:value-of select="$direction"/>
		<xsl:text>.html</xsl:text>
		</xsl:attribute><xsl:copy-of select="$text"/>
  </a>
</xsl:template>


</xsl:stylesheet>
