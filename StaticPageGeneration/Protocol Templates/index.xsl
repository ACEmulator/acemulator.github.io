<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:template name="index" match="/">
		<xsl:result-document href="./index.html" method="html">
			<html>
				<head>
					<title>AC Protocol version <xsl:value-of select="/schema/revision/@version"/>
					</title>
					<link type="text/css" rel="stylesheet" href="Classic.css"/>
				</head>
				<frameset rows="240, *" cols="*, *" frameborder="yes" framespacing="3">
					<frame name="frameMsgTOC" scrolling="yes" src="frameMsgTOC.html"/>
					<frame name="frameTypeTOC" scrolling="yes" src="frameTypeTOC.html"/>
					<frame name="frameMsg" scrolling="yes" src="frameMsg.html"/>
					<frame name="frameType" scrolling="yes" src="frameType.html"/>
				</frameset>
			</html>
		</xsl:result-document>
	</xsl:template>
</xsl:stylesheet>
