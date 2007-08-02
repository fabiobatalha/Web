<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:variable name="refId" select="//vars/refId"/>
	
	<xsl:template match="/">
	
			<xsl:apply-templates select="//wxis-modules/record[field/@tag = 888 and field/occ = $refId]/field[@tag=704]/occ"/>

	</xsl:template>
	
</xsl:stylesheet>
