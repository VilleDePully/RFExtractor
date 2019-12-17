<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:grundstueck="http://bedag.ch/capitastra/schemas/A51/v20140310/Datenexport/Grundstueck" exclude-result-prefixes="grundstueck" version="1.0">
<xsl:output method="text" encoding="iso-8859-1"/>
<!--
Auteur : Xavier M?n?trey / Arnaud Poncet-Montanges - SIGIP (Ville de Pully)
Version 2.0
Date : 04.06.2014 Dernière modification : 30.07.2018
Description: Ce script permet d'extraire les natures des bien-fonds et DDP
-->

<xsl:template match="grundstueck:GrundstueckExport">
  <!-- Cette partie definit les entetes qui seront en sortie du fichier .CSV -->
	<xsl:text>No_BF&#59;EGRID&#59;No_cant&#59;Commune&#59;Type_Nature&#59;Surface&#xa;</xsl:text>
	
	<!-- pour chaque BF-->
	<xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:GrundstueckList/grundstueck:Liegenschaft">
	
		<xsl:variable name="ID" select="grundstueck:GrundstueckID/text()"/>
		<xsl:variable name="Num_BF" select="grundstueck:GrundstueckNummer/grundstueck:StammNr/text()"/>
    <xsl:variable name="EGRID" select="grundstueck:EGrid/text()"/>
    <xsl:variable name="Num_cant" select="grundstueck:GrundstueckNummer/grundstueck:BfsNr/text()"/>
    <xsl:variable name="Commune" select="grundstueck:GrundstueckNummer/grundstueck:Gemeindenamen/text()"/>

    <!-- Extraction des types de nature et surface -->
		<xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:BodenbedeckungList/grundstueck:Bodenbedeckung/grundstueck:GrundstueckIDREF[.=$ID]">
			
			<xsl:variable name="Type_nature" select="parent::*/grundstueck:Art/grundstueck:TextFr/text()"/>
			<xsl:variable name="Surface_nature" select="parent::*/grundstueck:Flaeche/text()"/>
      
        <xsl:value-of select="$Num_BF"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$EGRID"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Num_cant"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Commune"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Type_nature"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Surface_nature"/><xsl:text>&#xa;</xsl:text>

		</xsl:for-each>
    <xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:GebaeudeList/grundstueck:Gebaeude/grundstueck:GrundstueckZuGebaeude/grundstueck:GrundstueckIDREF[.=$ID]">
			
			<xsl:variable name="Type_batiment" select="ancestor::grundstueck:Gebaeude/grundstueck:GebaeudeArten/grundstueck:GebaeudeArtCode/grundstueck:TextFr/text()"/>
			<xsl:variable name="Surface_batiment" select="parent::*/grundstueck:AbschnittFlaeche/text()"/>
      
        <xsl:value-of select="$Num_BF"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$EGRID"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Num_cant"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Commune"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Type_batiment"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Surface_batiment"/><xsl:text>&#xa;</xsl:text>

		</xsl:for-each>
	</xsl:for-each>
    
  <!-- pour chaque DDP-->
	<xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:GrundstueckList/grundstueck:Sdr">
	
		<xsl:variable name="ID" select="grundstueck:GrundstueckID/text()"/>
		<xsl:variable name="Num_DP" select="grundstueck:GrundstueckNummer/grundstueck:StammNr/text()"/>
    <xsl:variable name="EGRID" select="grundstueck:EGrid/text()"/>
    <xsl:variable name="Num_cant" select="grundstueck:GrundstueckNummer/grundstueck:BfsNr/text()"/>
    <xsl:variable name="Commune" select="grundstueck:GrundstueckNummer/grundstueck:Gemeindenamen/text()"/>
 
    <!-- Extraction des types de nature et surface -->
		<xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:BodenbedeckungList/grundstueck:Bodenbedeckung/grundstueck:GrundstueckIDREF[.=$ID]">
			
			<xsl:variable name="Type_nature" select="parent::*/grundstueck:Art/grundstueck:TextFr/text()"/>
			<xsl:variable name="Surface_nature" select="parent::*/grundstueck:Flaeche/text()"/>
      
        <xsl:value-of select="$Num_DP"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$EGRID"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Num_cant"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Commune"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Type_nature"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Surface_nature"/><xsl:text>&#xa;</xsl:text>

		</xsl:for-each>
    <!-- Extraction des types de bâtiments et surface -->
    <xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:GebaeudeList/grundstueck:Gebaeude/grundstueck:GrundstueckZuGebaeude/grundstueck:GrundstueckIDREF[.=$ID]">
			
			<xsl:variable name="Type_batiment" select="ancestor::grundstueck:Gebaeude/grundstueck:GebaeudeArten/grundstueck:GebaeudeArtCode/grundstueck:TextFr/text()"/>
			<xsl:variable name="Surface_batiment" select="parent::*/grundstueck:AbschnittFlaeche/text()"/>
      
        <xsl:value-of select="$Num_DP"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$EGRID"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Num_cant"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Commune"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Type_batiment"/><xsl:text>&#59;</xsl:text><xsl:value-of select="$Surface_batiment"/><xsl:text>&#xa;</xsl:text>

		</xsl:for-each>
	</xsl:for-each>

</xsl:template>

</xsl:stylesheet>