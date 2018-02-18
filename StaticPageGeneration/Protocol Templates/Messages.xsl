<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">

<xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0 Strict//EN" encoding="UTF-8"/>

<xsl:template name="AllMessages">
<xsl:for-each select="message[not(@unknown)]">
			<xsl:call-template name="OneMessage">
				<!--<xsl:with-param name="message" select="."/>-->
			</xsl:call-template>
</xsl:for-each>
</xsl:template>

<!-- Generate the full documentation for one message. -->
<xsl:template name="OneMessage" match="message">
  <xsl:variable name="type" select="@type"/>
  <xsl:variable name="msgEnum" select="/schema/datatypes/enums/enum[@name = 'MessageType']" />
  <xsl:variable name="msgEnumEntry" select="$msgEnum/value[@value = $type]"/>
  <xsl:variable name="direction" select="@direction"/>
  <xsl:result-document href="./Messages/{$type}-{$direction}.html" method="html">
  <html>
	<head>
	<title>AC Protocol version <xsl:value-of select="/schema/revision/@version"/></title>
	<link type="text/css" rel="stylesheet" href="../Classic.css"/>
	</head>
	
    <body>
	<xsl:call-template name="GenMessageTable">
		<xsl:with-param name="title"><b><xsl:value-of select="@type"/>:</b><xsl:text> </xsl:text><xsl:value-of select="$msgEnumEntry/@name"/></xsl:with-param>
		<xsl:with-param name="desc"><xsl:value-of select="@text"/></xsl:with-param>
		<xsl:with-param name="list" select="."/>
		<xsl:with-param name="ordered" select="@ordered"/>
    <xsl:with-param name="direction" select="@direction"/>
    <xsl:with-param name="type" select="@type"/>
		<xsl:with-param name="style">
			<xsl:choose>
				<xsl:when test="@retired">Retired</xsl:when>
				<xsl:otherwise>List</xsl:otherwise>
			</xsl:choose>
		</xsl:with-param>
	</xsl:call-template>
	
	<p class="Version">Messages.xml version <xsl:value-of select="/schema/revision/@version"/></p>
	
	</body></html>
  </xsl:result-document>
</xsl:template>

<xsl:template name="GenMessageTable">
  <xsl:param name="title"/>
  <xsl:param name="desc"/>
  <xsl:param name="list"/>
  <xsl:param name="case"/>
  <xsl:param name="ordered"/>
  <xsl:param name="direction"/>
  <xsl:param name="type"/>
  <xsl:param name="style" select="'List'"/>
  <xsl:param name="depth" select="0"/>
	
	<xsl:variable name="istyle" select="($depth mod 2) + 1"/>
	<xsl:variable name="styleTable"><xsl:value-of select="$style"/><xsl:value-of select="$istyle"/></xsl:variable>
	<xsl:variable name="styleHead">BoxHead<xsl:value-of select="$istyle"/></xsl:variable>
	
	<table cellspacing="0" cellpadding="0">
		<xsl:attribute name="class"><xsl:value-of select="$styleTable"/></xsl:attribute>
		
		<xsl:if test="$title">
			<tr>
				<td colspan="3">
					<p>
						<xsl:attribute name="class"><xsl:value-of select="$styleHead"/></xsl:attribute>
						<xsl:copy-of select="$title"/>
					</p>
				</td>
			</tr>
		</xsl:if>
		
		<tr>
			<td class="PadTop" colspan="3"/>
		</tr>
		
		<xsl:if test="$desc">
			<tr>
				<td colspan="3">
					<p class="BoxDesc"><xsl:value-of select="$desc"/></p>
				</td>
			</tr>
			<xsl:if test="count($list/*)">
				<tr>
					<td colspan="3" class="SeqRowSep">
						<p class="SeqRowSep"/>
					</td>
				</tr>
			</xsl:if>
		</xsl:if>

    
      
    <xsl:if test="$ordered = 'TRUE' and $direction">
      <tr class="SeqHeader">
        <td class="FieldType"><p class="FieldType"><span class="TypeRef" title="uint">uint</span></p></td>
        <td class="FieldName"><p class="FieldName">
           orderHdr = 
        <xsl:choose>
          <xsl:when test="$direction='S2C'">
            0xF7B0
          </xsl:when>
          <xsl:when test="$direction='C2S'">
            0xF7B1
          </xsl:when>
        </xsl:choose>
        </p></td>
        <td class="FieldDesc"><p class="FieldDesc">Value indicating this message has a sequencing header</p></td>
      </tr>
      <tr><td colspan="3" class="SeqRowSep"><p class="SeqRowSep"></p></td></tr>
      <tr class="SeqHeader">
        <td class="FieldType"><p class="FieldType"><span class="TypeRef" title="uint">ObjectID</span></p></td>
        <td class="FieldName"><p class="FieldName">characterID</p></td>
        <td class="FieldDesc"><p class="FieldDesc">the object ID of the message recipient (should be you)</p></td>
      </tr>
      <tr><td colspan="3" class="SeqRowSep"><p class="SeqRowSep"></p></td></tr>
      <tr class="SeqHeader">
        <td class="FieldType"><p class="FieldType"><span class="TypeRef" title="uint">uint</span></p></td>
        <td class="FieldName"><p class="FieldName">sequence</p></td>
        <td class="FieldDesc"><p class="FieldDesc">sequence number</p></td>
      </tr>
      <tr><td colspan="3" class="SeqRowSep"><p class="SeqRowSep"></p></td></tr>
		</xsl:if>
		
    <xsl:if test="$type">
      <tr>
        <td class="FieldType"><p class="FieldType"><span class="TypeRef" title="uint">
        <xsl:call-template name="GenLink">
			    <xsl:with-param name="frame">frameEnum</xsl:with-param>
			    <xsl:with-param name="type" select="'MessageType'"/>
			    <xsl:with-param name="text"><xsl:value-of select="'MessageType'"/></xsl:with-param>
		    </xsl:call-template>
        </span></p></td>
        <td class="FieldName"><p class="FieldName">type = <xsl:value-of select="$type"/></p></td>
        <td class="FieldDesc"><p class="FieldDesc">type of this message</p></td>
      </tr>
      <xsl:if test="count($list/*)">
				<tr>
					<td colspan="3" class="FieldRowSep">
						<p class="FieldRowSep"/>
					</td>
				</tr>
			</xsl:if>
    </xsl:if>
    
		<xsl:call-template name="GenFieldList">
			<xsl:with-param name="list" select="$list"/>
			<xsl:with-param name="case" select="$case"/>
			<xsl:with-param name="style" select="$style"/>
			<xsl:with-param name="depth" select="$depth"/>
		</xsl:call-template>
		
		<tr>
			<td class="PadBottom" colspan="3"/>
		</tr>
		
	</table>
	
</xsl:template>
    
<xsl:template name="GenFieldTable">
  <xsl:param name="title"/>
  <xsl:param name="desc"/>
  <xsl:param name="list"/>
  <xsl:param name="case"/>
  <xsl:param name="style" select="'List'"/>
  <xsl:param name="depth" select="0"/>
	
	<xsl:variable name="istyle" select="($depth mod 2) + 1"/>
	<xsl:variable name="styleTable"><xsl:value-of select="$style"/><xsl:value-of select="$istyle"/></xsl:variable>
	<xsl:variable name="styleHead">BoxHead<xsl:value-of select="$istyle"/></xsl:variable>
	
	<table cellspacing="0" cellpadding="0">
		<xsl:attribute name="class"><xsl:value-of select="$styleTable"/></xsl:attribute>
		
		<xsl:if test="$title">
			<tr>
				<td colspan="3">
					<p>
						<xsl:attribute name="class"><xsl:value-of select="$styleHead"/></xsl:attribute>
						<xsl:copy-of select="$title"/>
					</p>
				</td>
			</tr>
		</xsl:if>
		
		<tr>
			<td class="PadTop" colspan="3"/>
		</tr>
		
		<xsl:if test="$desc">
			<tr>
				<td colspan="3">
					<p class="BoxDesc"><xsl:value-of select="$desc"/></p>
				</td>
			</tr>
			<xsl:if test="count($list/*)">
				<tr>
					<td colspan="3" class="FieldRowSep">
						<p class="FieldRowSep"/>
					</td>
				</tr>
			</xsl:if>
		</xsl:if>

		<xsl:call-template name="GenFieldList">
			<xsl:with-param name="list" select="$list"/>
			<xsl:with-param name="case" select="$case"/>
			<xsl:with-param name="style" select="$style"/>
			<xsl:with-param name="depth" select="$depth"/>
		</xsl:call-template>
		
		<tr>
			<td class="PadBottom" colspan="3"/>
		</tr>
		
	</table>
	
</xsl:template>

<xsl:template name="GenCaseTable">
  <xsl:param name="title"/>
  <xsl:param name="list"/>
  <xsl:param name="case"/>
  <xsl:param name="style" select="'List'"/>
  <xsl:param name="depth" select="0"/>
	
	<xsl:variable name="istyle" select="($depth mod 2) + 1"/>
	<xsl:variable name="styleTable">CaseList<xsl:value-of select="$istyle"/></xsl:variable>
	<xsl:variable name="styleHead">CaseHead<xsl:value-of select="$istyle"/></xsl:variable>
	
	<table cellspacing="0" cellpadding="0">
		<xsl:attribute name="class"><xsl:value-of select="$styleTable"/></xsl:attribute>
		
		<tr>
			<td colspan="2">
				<p>
					<xsl:attribute name="class"><xsl:value-of select="$styleHead"/></xsl:attribute>
					<xsl:copy-of select="$title"/>
				</p>
			</td>
		</tr>
		
		<xsl:call-template name="GenFieldList">
			<xsl:with-param name="list" select="$list"/>
			<xsl:with-param name="case" select="$case"/>
			<xsl:with-param name="style" select="$style"/>
			<xsl:with-param name="depth" select="$depth"/>
		</xsl:call-template>
		
	</table>
	
</xsl:template>

<xsl:template name="GenCaseEntry">
  <xsl:param name="case"/>
  <xsl:param name="style" select="'List'"/>
  <xsl:param name="depth" select="0"/>
	
	<xsl:variable name="istyle" select="($depth mod 2) + 1"/>
	<xsl:variable name="styleVal">CaseVal<xsl:value-of select="$istyle"/></xsl:variable>
	<xsl:variable name="styleFields">CaseFields<xsl:value-of select="$istyle"/></xsl:variable>
	
	<tr>
		<td><xsl:attribute name="class"><xsl:value-of select="$styleVal"/></xsl:attribute>
			<p><xsl:attribute name="class"><xsl:value-of select="$styleVal"/></xsl:attribute>
				<xsl:value-of select="$case/@value"/>
			</p>
		</td>
		<td><xsl:attribute name="class"><xsl:value-of select="$styleFields"/></xsl:attribute>
			<xsl:call-template name="GenFieldTable">
				<xsl:with-param name="desc" select="$case/@text"/>
				<xsl:with-param name="list" select="$case"/>
				<xsl:with-param name="style" select="$style"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
		</td>
	</tr>
	
</xsl:template>

<xsl:template name="GenIfTable">
  <xsl:param name="title"/>
  <xsl:param name="list"/>
  <xsl:param name="case"/>
  <xsl:param name="style" select="'List'"/>
  <xsl:param name="depth" select="0"/>
	
	<xsl:variable name="istyle" select="($depth mod 2) + 1"/>
	<xsl:variable name="styleTable">CaseList<xsl:value-of select="$istyle"/></xsl:variable>
	<xsl:variable name="styleHead">CaseHead<xsl:value-of select="$istyle"/></xsl:variable>
	
	<table cellspacing="0" cellpadding="0">
		<xsl:attribute name="class"><xsl:value-of select="$styleTable"/></xsl:attribute>
		
		<tr>
			<td colspan="2">
				<p>
					<xsl:attribute name="class"><xsl:value-of select="$styleHead"/></xsl:attribute>
					<xsl:copy-of select="$title"/>
				</p>
			</td>
		</tr>
		
		<xsl:call-template name="GenFieldList">
			<xsl:with-param name="list" select="$list"/>
			<xsl:with-param name="case" select="$case"/>
			<xsl:with-param name="style" select="$style"/>
			<xsl:with-param name="depth" select="$depth"/>
		</xsl:call-template>
		
	</table>
	
</xsl:template>

<xsl:template name="GenIfEntry">
  <xsl:param name="case"/>
  <xsl:param name="style" select="'List'"/>
  <xsl:param name="depth" select="0"/>
	
	<xsl:variable name="istyle" select="($depth mod 2) + 1"/>
	<xsl:variable name="styleVal">CaseVal<xsl:value-of select="$istyle"/></xsl:variable>
	<xsl:variable name="styleFields">CaseFields<xsl:value-of select="$istyle"/></xsl:variable>
	
	<tr>
		<td><xsl:attribute name="class"><xsl:value-of select="$styleVal"/></xsl:attribute>
			<p><xsl:attribute name="class"><xsl:value-of select="$styleVal"/></xsl:attribute>
				<xsl:value-of select="name($case)"/>
			</p>
		</td>
		<td><xsl:attribute name="class"><xsl:value-of select="$styleFields"/></xsl:attribute>
			<xsl:call-template name="GenFieldTable">
				<xsl:with-param name="desc" select="$case/@text"/>
				<xsl:with-param name="list" select="$case"/>
				<xsl:with-param name="style" select="$style"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
		</td>
	</tr>
	
</xsl:template>

<xsl:template name="GenFieldList">
  <xsl:param name="list"/>
  <xsl:param name="case"/>
  <xsl:param name="style" select="'List'"/>
  <xsl:param name="depth" select="0"/>
	
	<xsl:for-each select="$list/*">
		<xsl:choose>
		<xsl:when test="name(.) = 'switch'">
			
			<tr>
				<td class="NestedTable" colspan="3">
					<xsl:call-template name="GenCaseTable">
						<xsl:with-param name="title">Select one section based on the value of <b><xsl:value-of select="@name"/></b></xsl:with-param>
						<xsl:with-param name="list" select="."/>
						<xsl:with-param name="case" select="$case"/>
						<xsl:with-param name="style" select="$style"/>
						<xsl:with-param name="depth" select="$depth"/>
					</xsl:call-template>
				</td>
			</tr>
			
		</xsl:when>
		<xsl:when test="name(.) = 'case'">
			
			<xsl:if test="$case = '' or $case = @value">
				<xsl:call-template name="GenCaseEntry">
					<xsl:with-param name="case" select="."/>
					<xsl:with-param name="style">
						<xsl:choose>
							<xsl:when test="@retired">Retired</xsl:when>
							<xsl:otherwise><xsl:value-of select="$style"/></xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="depth" select="$depth"/>
				</xsl:call-template>
			</xsl:if>
			
		</xsl:when>
    <xsl:when test="name(.) = 'if'">
			
			<tr>
				<td class="NestedTable" colspan="3">
					<xsl:call-template name="GenIfTable">
						<xsl:with-param name="title">Choose based on testing <b><xsl:value-of select="@test"/></b></xsl:with-param>
						<xsl:with-param name="list" select="."/>
						<xsl:with-param name="case" select="$case"/>
						<xsl:with-param name="style" select="$style"/>
						<xsl:with-param name="depth" select="$depth"/>
					</xsl:call-template>
				</td>
			</tr>
			
		</xsl:when>
    <xsl:when test="name(.) = 'true' or name(.) = 'false'">
			
			<xsl:call-template name="GenIfEntry">
				<xsl:with-param name="case" select="."/>
				<xsl:with-param name="style" select="$style"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
			
		</xsl:when>
		<xsl:when test="name(.) = 'maskmap'">
			
			<tr>
				<td class="NestedTable" colspan="3">
					<xsl:call-template name="GenCaseTable">
						<xsl:with-param name="title">Choose valid sections by masking against <b><xsl:value-of select="@name"/><xsl:if test="@xor"> xor <xsl:value-of select="@xor"/></xsl:if></b></xsl:with-param>
						<xsl:with-param name="list" select="."/>
						<xsl:with-param name="case" select="$case"/>
						<xsl:with-param name="style" select="$style"/>
						<xsl:with-param name="depth" select="$depth"/>
					</xsl:call-template>
				</td>
			</tr>
			
		</xsl:when>
		<xsl:when test="name(.) = 'mask'">
			
			<xsl:call-template name="GenCaseEntry">
				<xsl:with-param name="case" select="."/>
				<xsl:with-param name="style" select="$style"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
			
		</xsl:when>
		<xsl:when test="name(.) = 'vector'">
			
			<tr>
				<td class="NestedTable" colspan="3">
					<xsl:call-template name="GenFieldTable">
						<xsl:with-param name="title"><b><xsl:value-of select="@name"/></b>: vector of length <b><xsl:value-of select="@length"/></b></xsl:with-param>
						<xsl:with-param name="list" select="."/>
						<xsl:with-param name="style" select="$style"/>
						<xsl:with-param name="depth" select="$depth + 1"/>
					</xsl:call-template>
				</td>
			</tr>
			
		</xsl:when>
		<xsl:when test="name(.) = 'group'">
			
			<tr>
				<td class="NestedTable" colspan="3">
					<xsl:call-template name="GenFieldTable">
						<xsl:with-param name="title"><b><xsl:value-of select="@name"/></b>: <xsl:value-of select="@text"/></xsl:with-param>
						<xsl:with-param name="list" select="."/>
						<xsl:with-param name="style" select="$style"/>
						<xsl:with-param name="depth" select="$depth"/>
					</xsl:call-template>
				</td>
			</tr>
			
		</xsl:when>
		<xsl:when test="name(.) = 'base'">
			
			<xsl:variable name="type" select="@type"/>
			<xsl:variable name="typedef" select="/schema/datatypes/types/type[@name = $type]"/>
			
			<xsl:call-template name="GenFieldList">
				<xsl:with-param name="list" select="$typedef"/>
				<xsl:with-param name="case" select="$case"/>
				<xsl:with-param name="style" select="$style"/>
				<xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
			
		</xsl:when>
		<xsl:when test="name(.) = 'field' or name(.) = 'member'">
			
			<xsl:if test="position() > 1">
				<xsl:variable name="ifieldPrev" select="position() - 1"/>
				<xsl:variable name="fieldPrev" select="$list/*[$ifieldPrev]"/>
				<xsl:if test="name($fieldPrev) = 'field' or name($fieldPrev) = 'member'">
					<tr>
						<td colspan="3" class="FieldRowSep">
							<p class="FieldRowSep"/>
						</td>
					</tr>
				</xsl:if>
			</xsl:if>
			
			<xsl:call-template name="GenField">
				<xsl:with-param name="field" select="."/>
        <xsl:with-param name="case" select="$case"/>
        <xsl:with-param name="style" select="$style"/>
        <xsl:with-param name="depth" select="$depth"/>
			</xsl:call-template>
			
		</xsl:when>
    <xsl:when test="name(.) = 'subfield' or name(.) = 'submember'">

      <xsl:if test="position() > 1">
        <xsl:variable name="ifieldPrev" select="position() - 1"/>
        <xsl:variable name="fieldPrev" select="$list/*[$ifieldPrev]"/>
        <xsl:if test="name($fieldPrev) = 'field' or name($fieldPrev) = 'member'">
          <tr>
            <td colspan="3" class="FieldRowSep">
              <p class="FieldRowSep"/>
            </td>
          </tr>
        </xsl:if>
      </xsl:if>

      <xsl:call-template name="GenSubField">
        <xsl:with-param name="field" select="."/>
      </xsl:call-template>

    </xsl:when>
		<xsl:when test="name(.) = 'align'">
			
			<tr>
				<td colspan="3">
					<p class="Align">Align to <b><xsl:value-of select="@type"/></b> boundary</p>
				</td>
			</tr>
			
		</xsl:when>
		</xsl:choose>
	</xsl:for-each>
	
</xsl:template>

<xsl:template name="GenField">
  <xsl:param name="field"/>
  <xsl:param name="case"/>
  <xsl:param name="style" select="'List'"/>
  <xsl:param name="depth" select="0"/>
  
	<tr>
		<td class="FieldType">
			<p class="FieldType">
				<xsl:call-template name="GenTypeRef">
				  <xsl:with-param name="field" select="$field"/>
				</xsl:call-template>
			</p>
		</td>
		<td class="FieldName">
			<p class="FieldName">
				<xsl:value-of select="$field/@name"/>
        <xsl:if test="$field/@staticValue">
          = <xsl:value-of select="$field/@staticValue"/>
        </xsl:if>
			</p>
		</td>
		<td class="FieldDesc">
			<p class="FieldDesc">
        <xsl:if test="$field/submember | $field/subfield">
          write: 
          <xsl:for-each select="$field/*">
              <xsl:if test="position() > 1">
                | 
              </xsl:if>
              (<xsl:value-of select="./@name"/>
              <xsl:if test="./@and">
               &amp; <xsl:value-of select="./@and"/>
              </xsl:if>
              <xsl:if test="./@shift">
               &lt;&lt; <xsl:value-of select="./@shift"/>
              </xsl:if>)
          </xsl:for-each>
          <xsl:if test="$field/@text">
          ;
          </xsl:if>
        </xsl:if>
        <xsl:value-of select="$field/@text"/>
			</p>
		</td>
	</tr>

  <xsl:call-template name="GenFieldList">
    <xsl:with-param name="list" select="$field"/>
    <xsl:with-param name="case" select="$case"/>
    <xsl:with-param name="style" select="$style"/>
    <xsl:with-param name="depth" select="$depth"/>
  </xsl:call-template>
  
</xsl:template>

<xsl:template name="GenSubField">
    <xsl:param name="field"/>

    <tr align="right">
      <td class="FieldType">
        <p class="FieldType">
          <xsl:call-template name="GenTypeRef">
            <xsl:with-param name="field" select="$field"/>
          </xsl:call-template>
        </p>
      </td>
      <td class="FieldName">
        <p class="FieldName">
          <xsl:value-of select="$field/@name"/>
        </p>
      </td>
      <td class="FieldDesc">
        <p class="FieldDesc">
          read: 
          <xsl:if test="$field/@shift | $field/@and">
           <xsl:value-of select="$field/../@name"/>
          </xsl:if>
          <xsl:if test="$field/@shift">
           &gt;&gt; <xsl:value-of select="$field/@shift"/>
          </xsl:if>
          <xsl:if test="$field/@and">
           &amp; <xsl:value-of select="$field/@and"/>
          </xsl:if>
          <xsl:if test="$field/@value">
           <xsl:value-of select="$field/@value"/>
          </xsl:if>
          <xsl:if test="$field/@text">
           ; <xsl:value-of select="$field/@text"/>
          </xsl:if>
        </p>
      </td>
    </tr>

  </xsl:template>

<xsl:template name="GenTypeRef">
  <xsl:param name="field"/>
  <xsl:call-template name="GenTypeRefLink">
    <xsl:with-param name="type"><xsl:value-of select="$field//@type"/></xsl:with-param>
	</xsl:call-template>
  <xsl:choose>
	  <xsl:when test="$field//@genericType">&lt;<xsl:call-template name="GenTypeRefLink">
        <xsl:with-param name="type"><xsl:value-of select="$field//@genericType"/></xsl:with-param>
	    </xsl:call-template>&gt;</xsl:when>
	  <xsl:otherwise>
      <xsl:choose>
	      <xsl:when test="$field//@genericKey and $field//@genericValue">&lt;<xsl:call-template name="GenTypeRefLink">
            <xsl:with-param name="type"><xsl:value-of select="$field//@genericKey"/></xsl:with-param>
	        </xsl:call-template>,<xsl:call-template name="GenTypeRefLink">
            <xsl:with-param name="type"><xsl:value-of select="$field//@genericValue"/></xsl:with-param>
	        </xsl:call-template>&gt;</xsl:when>
	      <xsl:otherwise>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:otherwise>
	</xsl:choose>
</xsl:template>
    
<xsl:template name="GenTypeRefLink">
  <xsl:param name="type"/>
	<xsl:variable name="typedef" select="/schema/datatypes/types/type[@name = $type]"/>
  <xsl:variable name="typedef2" select="/schema/datatypes/enums/enum[@name = $type]"/>
	<xsl:variable name="tip">
		<xsl:choose>
		<xsl:when test="$typedef//member">Struct</xsl:when>
		<xsl:otherwise><xsl:value-of select="$typedef/@parent"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<span class="TypeRef"><xsl:attribute name="title"><xsl:value-of select="$tip"/></xsl:attribute>
	<xsl:choose>
	<xsl:when test="($typedef//member | $typedef//value | $typedef//mask) or $typedef/@text">
		<xsl:call-template name="GenLink">
			<xsl:with-param name="frame">frameType</xsl:with-param>
			<xsl:with-param name="type" select="$type"/>
			<xsl:with-param name="text"><xsl:value-of select="$type"/></xsl:with-param>
		</xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
		<xsl:choose>
	    <xsl:when test="($typedef2//member | $typedef2//value | $typedef2//mask) or $typedef2/@text">
		    <xsl:call-template name="GenLink">
			    <xsl:with-param name="frame">frameEnum</xsl:with-param>
			    <xsl:with-param name="type" select="$type"/>
			    <xsl:with-param name="text"><xsl:value-of select="$type"/></xsl:with-param>
		    </xsl:call-template>
	    </xsl:when>
	    <xsl:otherwise>
		    <xsl:value-of select="$type"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:otherwise>
	</xsl:choose>
	</span>
</xsl:template>


<xsl:template name="GenValueTable">
  <xsl:param name="title"/>
  <xsl:param name="desc"/>
  <xsl:param name="list"/>
  <xsl:param name="style" select="'List'"/>
  <xsl:param name="depth" select="0"/>
	
	<xsl:variable name="istyle" select="($depth mod 2) + 1"/>
	<xsl:variable name="styleTable"><xsl:value-of select="$style"/><xsl:value-of select="$istyle"/></xsl:variable>
	<xsl:variable name="styleHead">BoxHead<xsl:value-of select="$istyle"/></xsl:variable>
	
	<table cellspacing="0" cellpadding="0">
		<xsl:attribute name="class"><xsl:value-of select="$styleTable"/></xsl:attribute>
		
		<tr>
			<td colspan="3">
				<p>
					<xsl:attribute name="class"><xsl:value-of select="$styleHead"/></xsl:attribute>
					<xsl:copy-of select="$title"/>
				</p>
			</td>
		</tr>
		
		<tr>
			<td class="PadTop" colspan="2"/>
		</tr>
		
		<xsl:if test="$desc">
			<tr>
				<td colspan="3">
					<p class="BoxDesc"><xsl:value-of select="$desc"/></p>
				</td>
			</tr>
			<xsl:if test="count($list/*)">
				<tr>
					<td colspan="3" class="ValueRowSep">
						<p class="ValueRowSep"/>
					</td>
				</tr>
			</xsl:if>
		</xsl:if>
		
		<xsl:call-template name="GenValueList">
			<xsl:with-param name="list" select="$list"/>
		</xsl:call-template>
		
		<tr>
			<td class="PadBottom" colspan="2"/>
		</tr>
		
	</table>
	
</xsl:template>

<xsl:template name="GenValueList">
  <xsl:param name="list"/>
	
	<xsl:for-each select="$list/*">
		<xsl:choose>
		<xsl:when test="name(.) = 'mask' or name(.) = 'value'">
			
			<xsl:if test="position() > 1">
				<tr>
					<td colspan="3" class="ValueRowSep">
						<p class="ValueRowSep"/>
					</td>
				</tr>
			</xsl:if>
			
			<xsl:call-template name="GenValue">
			  <xsl:with-param name="value" select="."/>
			</xsl:call-template>
			
		</xsl:when>
		</xsl:choose>
	</xsl:for-each>
	
</xsl:template>

<xsl:template name="GenValue">
  <xsl:param name="value"/>
	
	<tr>
		<td class="ValueVal">
			<p class="ValueVal">
				<xsl:value-of select="$value/@value"/>
			</p>
		</td>
    <td class="ValueName">
			<p class="ValueName">
				<xsl:value-of select="$value/@name"/>
			</p>
		</td>
    <td class="ValueDesc">
    <xsl:if test="$value/@text and $value/@text != ''">
			<p class="ValueDesc">
				<xsl:value-of select="$value/@text"/>
			</p>
		</xsl:if>
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
		  <xsl:when test="$frame = 'frameEnum'">../Types/</xsl:when>
		  <xsl:when test="$frame = 'frameType'">../Types/</xsl:when>
		  <xsl:otherwise>Messages/</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$type"/>
		<xsl:text>.html</xsl:text></xsl:attribute>
		<xsl:copy-of select="$text"/>
  </a>
</xsl:template>

</xsl:stylesheet>
