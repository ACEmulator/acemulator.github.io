<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:php="http://php.net/xsl"
  version="1.0">
<xsl:output method="html" encoding="UTF-8"/>


<xsl:param name="URLPrefix"/>
<xsl:param name="elemToTransform"/>

<xsl:template match="/">
	<xsl:apply-templates select="php:function('ElemFromXpath', $elemToTransform)"/>
</xsl:template>


<!-- Generate the message TOC. -->
<xsl:template match="messages">
	
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
	
</xsl:template>

<!-- Generate the TOC entry for one message. -->
<xsl:template name="GenTOCMsg">
  <xsl:param name="message"/>
	
	<tr>
		<td class="TOCEntry">
			<p>
			<xsl:attribute name="class"><xsl:choose>
			  <xsl:when test="$message/@retired">TOC1Retired</xsl:when>
			  <xsl:otherwise>TOC1</xsl:otherwise>
			  </xsl:choose></xsl:attribute>
			<xsl:call-template name="GenLink">
				<xsl:with-param name="frame">frameMsg</xsl:with-param>
				<xsl:with-param name="type" select="$message/@type"/>
				<xsl:with-param name="text"><b><xsl:value-of select="$message/@type"/>:</b><xsl:text> </xsl:text><xsl:value-of select="$message/@name"/></xsl:with-param>
			</xsl:call-template>
			</p>
		</td>
	</tr>
	
	<xsl:if test="$message/@type = 'F7B0' or $message/@type = 'F7B1'">
		<xsl:for-each select="$message/switch">
			<xsl:variable name="casefield" select="$message/field[@name = ./@name]"/>
			<xsl:variable name="casetype" select="/schema/datatypes/type[@name = $casefield/@type]"/>
			<xsl:for-each select="case[not(@unknown)]">
				<xsl:call-template name="GenTOCCase">
					<xsl:with-param name="type" select="$message/@type"/>
					<xsl:with-param name="casetype" select="$casetype"/>
					<xsl:with-param name="case" select="."/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:if>
	
</xsl:template>

<!-- Generate the TOC entry for one message subtype. -->
<xsl:template name="GenTOCCase">
  <xsl:param name="type"/>
  <xsl:param name="casetype"/>
  <xsl:param name="case"/>
	
	<xsl:variable name="casedesc" select="$casetype/value[@value = $case/@value]"/>
	
	<tr>
		<td class="TOCEntry">
			<p>
			<xsl:attribute name="class"><xsl:choose>
				<xsl:when test="$case/@retired">TOC2Retired</xsl:when>
				<xsl:otherwise>TOC2</xsl:otherwise>
				</xsl:choose></xsl:attribute>
			<xsl:call-template name="GenLink">
				<xsl:with-param name="frame">frameMsg</xsl:with-param>
				<xsl:with-param name="type" select="$type"/>
				<xsl:with-param name="case" select="$case/@value"/>
				<xsl:with-param name="text"><b><xsl:value-of select="$case/@value"/>:</b><xsl:text> </xsl:text><xsl:value-of select="$casedesc/@text"/></xsl:with-param>
			</xsl:call-template>
			</p>
		</td>
	</tr>
	
</xsl:template>


<!-- Generate the type TOC. -->
<xsl:template match="datatypes">
	
	<table cellspacing="0" cellpadding="0" class="TOC">
		<tr>
			<td class="TOCHead">
				<p class="TOCHead">Struct types</p>
			</td>
		</tr>
	
		<xsl:for-each select="type[count(.//member) != 0]">
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
	
		<xsl:for-each select="type[value | mask]">
			<xsl:sort select="@name"/>
			<xsl:call-template name="GenTOCType">
				<xsl:with-param name="typedef" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	</table>
	
	<!-- Might be nice to put mask types in a separate table from enums, 
	     except that they aren't consistently defined using "mask" instead of "value".
	<table cellspacing="0" cellpadding="0" class="TOC">
		<tr>
			<td class="TOCHead">
				<p class="TOCHead">Mask types</p>
			</td>
		</tr>
	
		<xsl:for-each select="type[mask]">
			<xsl:sort select="@name"/>
			<xsl:call-template name="GenTOCType">
				<xsl:with-param name="typedef" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	</table>
	-->
	
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


<!-- Generate the full documentation for one message. -->
<xsl:template match="message">
	
	<xsl:call-template name="GenFieldTable">
		<xsl:with-param name="title"><b><xsl:value-of select="@type"/>:</b><xsl:text> </xsl:text><xsl:value-of select="@name"/></xsl:with-param>
		<xsl:with-param name="desc"><xsl:value-of select="@text"/></xsl:with-param>
		<xsl:with-param name="list" select="."/>
		<xsl:with-param name="case">
			<xsl:if test="@type = 'F7B0' or @type = 'F7B1'">None</xsl:if>
		</xsl:with-param>
		<xsl:with-param name="style">
			<xsl:choose>
				<xsl:when test="@retired">Retired</xsl:when>
				<xsl:otherwise>List</xsl:otherwise>
			</xsl:choose>
		</xsl:with-param>
	</xsl:call-template>
	
	<p class="Version">Messages.xml version <xsl:value-of select="/schema/revision/@version"/></p>
	
</xsl:template>

<!-- Generate the full documentation for one message subtype. -->
<xsl:template match="case">

	<xsl:variable name="msg" select="parent::node()/parent::node()"></xsl:variable>
	
	<xsl:call-template name="GenFieldTable">
		<xsl:with-param name="title"><b><xsl:value-of select="$msg/@type"/>:</b><xsl:text> </xsl:text><xsl:value-of select="$msg/@name"/></xsl:with-param>
		<xsl:with-param name="desc"><xsl:value-of select="$msg/@text"/></xsl:with-param>
		<xsl:with-param name="list" select="$msg"/>
		<xsl:with-param name="case" select="@value"/>
	</xsl:call-template>
	
	<p class="Version">Messages.xml version <xsl:value-of select="/schema/revision/@version"/></p>
	
</xsl:template>


<!-- Generate the full documentation for one type. -->
<xsl:template match="type">

	<xsl:variable name="title"><b><xsl:value-of select="@name"/></b><xsl:if test="@parent">: <xsl:value-of select="@parent"/></xsl:if></xsl:variable>
	
	<xsl:choose>
	<xsl:when test=".//member">
		<xsl:call-template name="GenFieldTable">
			<xsl:with-param name="title"><xsl:copy-of select="$title"/></xsl:with-param>
			<xsl:with-param name="desc" select="@text"/>
			<xsl:with-param name="list" select="."/>
			<xsl:with-param name="depth" select="1"/>
		</xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
		<xsl:call-template name="GenValueTable">
			<xsl:with-param name="title"><xsl:copy-of select="$title"/></xsl:with-param>
			<xsl:with-param name="desc" select="@text"/>
			<xsl:with-param name="list" select="."/>
			<xsl:with-param name="depth" select="1"/>
		</xsl:call-template>
	</xsl:otherwise>
	</xsl:choose>
	
	<p class="Version">Messages.xml version <xsl:value-of select="/schema/revision/@version"/></p>
	
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
			<xsl:variable name="typedef" select="/schema/datatypes/type[@name = $type]"/>
			
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
				  <xsl:with-param name="type" select="$field/@type"/>
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
            <xsl:with-param name="type" select="$field/@type"/>
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
          Value computed with <xsl:value-of select="$field/@value"/>
        </p>
      </td>
    </tr>

  </xsl:template>

<xsl:template name="GenTypeRef">
  <xsl:param name="type"/>
  	
	<xsl:variable name="typedef" select="/schema/datatypes/type[@name = $type]"/>
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
		<xsl:value-of select="$type"/>
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
			<td colspan="2">
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
				<td colspan="2">
					<p class="BoxDesc"><xsl:value-of select="$desc"/></p>
				</td>
			</tr>
			<xsl:if test="count($list/*)">
				<tr>
					<td colspan="2" class="ValueRowSep">
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
					<td colspan="2" class="ValueRowSep">
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
		<td class="ValueDesc">
			<p class="ValueDesc">
				<xsl:value-of select="$value/@text"/>
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
		<xsl:attribute name="target"><xsl:value-of select="$frame"/></xsl:attribute>
		<xsl:attribute name="href"><xsl:value-of select="$URLPrefix"/><xsl:text
			/>&amp;frame=<xsl:value-of select="$frame"/><xsl:text
			/>&amp;type=<xsl:value-of select="$type"/><xsl:text
			/><xsl:if test="$case">&amp;case=<xsl:value-of select="$case"/></xsl:if><xsl:text
			/></xsl:attribute>
		<xsl:copy-of select="$text"/>
	</a>
	
</xsl:template>


</xsl:stylesheet>
