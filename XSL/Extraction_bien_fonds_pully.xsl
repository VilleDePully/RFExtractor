<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:grundstueck="http://bedag.ch/capitastra/schemas/A51/v20140310/Datenexport/Grundstueck" exclude-result-prefixes="grundstueck" version="1.0">
<xsl:output method="text" encoding="iso-8859-1"/>
<!--
Auteur : Xavier Ménétrey / Arnaud Poncet-Montanges - SIGIP (Ville de Pully)
Version 2.0
Date : 04.06.2014 Derniere revision 30.07.2018
Cet export permet l'extraction des bien fonds, coproprietes, proprietes par etage (PPE), de même que leur proprietaires et l'estimation fiscale liee
-->

<xsl:template match="grundstueck:GrundstueckExport">
  <!-- Cette partie definit les entetes qui seront en sortie du fichier .CSV -->
  <xsl:text>No_cant&#59;No_BF&#59;EGRID&#59;No_PPE&#59;No_Copropriete&#59;BF&#59;PPE&#59;Copropriete&#59;AdresseBF&#59;Surface_m2&#59;Date_acquisition&#59;Motif_acquisition&#59;Estimation_Fiscale&#59;Proprietaire&#59;Adresse&#xa;</xsl:text>

  <!-- pour chaque copropriete-->
  <xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:GrundstueckList/grundstueck:GewoehnlichesMiteigentum">

    <xsl:variable name="ID" select="grundstueck:GrundstueckID/text()"/>
    <xsl:variable name="EGRID" select="grundstueck:EGrid/text()"/>
    <xsl:variable name="Num_cant" select="grundstueck:GrundstueckNummer/grundstueck:BfsNr/text()"/>
    <xsl:variable name="Num_copro" select="grundstueck:GrundstueckNummer/grundstueck:StammNr/text()"/>
    <xsl:variable name="Num_niv1" select="grundstueck:StammGrundstueck/grundstueck:BelastetesGrundstueck/grundstueck:GrundstueckNummer/grundstueck:StammNr/text()"/>
    <xsl:variable name="Type_noeud" select="concat('grundstueck:',grundstueck:StammGrundstueck/grundstueck:BelastetesGrundstueck/grundstueck:GrundstueckArt/text())"/>
    <xsl:variable name="Num_niv2" select="/grundstueck:GrundstueckExport/grundstueck:GrundstueckList/*[name()=$Type_noeud]/grundstueck:GrundstueckNummer/grundstueck:StammNr[.=$Num_niv1]/ancestor::*[name()=$Type_noeud]/grundstueck:StammGrundstueck/grundstueck:BelastetesGrundstueck/grundstueck:GrundstueckNummer/grundstueck:StammNr/text()"/>
    <xsl:variable name="Num_copro_old_style" select="grundstueck:GrundstueckNummer/grundstueck:IndexNr2/text()"/>
    <xsl:variable name="Num_PPE_old_style" select="grundstueck:GrundstueckNummer/grundstueck:IndexNr1/text()"/>
    <xsl:variable name="AdresseBF" select="/grundstueck:GrundstueckExport/grundstueck:GrundstueckAdresseList/grundstueck:GrundstueckAdresse/grundstueck:GrundstueckIDREF[.=$ID]/parent::*/grundstueck:AdresseText/text()"/>
    <xsl:variable name="Val_estimation" select="grundstueck:AmtlicheBewertung/grundstueck:AmtlicherWert/text()"/>
    <xsl:variable name="Protokol_estimation" select="grundstueck:AmtlicheBewertung/grundstueck:ProtokollNr/text()"/>
    <xsl:variable name="ProtokolDatum_estimation" select="grundstueck:AmtlicheBewertung/grundstueck:ProtokollDatum/text()"/>
        
    <xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:EigentumList/grundstueck:PersonEigentumAnteil/grundstueck:BelastetesGrundstueckIDREF[.=$ID]">
      <xsl:variable name="ID_pers" select="parent::*/*/grundstueck:PersonstammIDREF/text()"/>
      <xsl:variable name="Type_pers" select="name(/grundstueck:GrundstueckExport/grundstueck:PersonstammList/*/grundstueck:PersonstammID[.=$ID_pers]/parent::*)"/>
            <xsl:variable name="Motif_Acquisition" select="parent::*/*/grundstueck:Rechtsgruende[last()]/grundstueck:RechtsgrundCode/grundstueck:TextFr/text()"/>
            <xsl:variable name="Date_Acquisition" select="parent::*/*/grundstueck:Rechtsgruende[last()]/grundstueck:BelegDatum/text()"/>
      <xsl:if test="$ID_pers!=''">
        <xsl:if test="$Type_noeud!='grundstueck:SelbstaendigesDauerndesRecht'">
        <xsl:choose>
          <xsl:when test="$Type_noeud='grundstueck:StockwerksEinheit'">
                        <xsl:choose>
                            <xsl:when test="$Num_copro_old_style!='' and $Num_PPE_old_style!=''"> <!-- Ancienne notation pour les PPE et les copropri�t�s -->
                                <xsl:value-of select="$Num_cant"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$Num_niv2"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$EGRID"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$Num_niv1"/><xsl:text>-</xsl:text><xsl:value-of select="$Num_PPE_old_style"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$Num_niv1"/><xsl:text>-</xsl:text><xsl:value-of select="$Num_PPE_old_style"/><xsl:text>-</xsl:text><xsl:value-of select="$Num_copro_old_style"/><xsl:text>&#59;&#59;&#59;x&#59;</xsl:text>
                            </xsl:when>
                            <xsl:when test="string-length($Num_copro_old_style)=0 and $Num_PPE_old_style!=''"> <!-- Ancienne notation pour les copropri�t�s uniquement. Dans ce cas-ci le num de PPE refl�te le num de copropri�t� -->
                                <xsl:value-of select="$Num_cant"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$Num_niv2"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$EGRID"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$Num_niv1"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$Num_niv1"/><xsl:text>-</xsl:text><xsl:value-of select="$Num_PPE_old_style"/><xsl:text>&#59;&#59;&#59;x&#59;</xsl:text>
                            </xsl:when>
                            <xsl:otherwise> <!-- Nouvelle notation -->
                                <xsl:value-of select="$Num_cant"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$Num_niv2"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$EGRID"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$Num_niv1"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$Num_copro"/><xsl:text>&#59;&#59;&#59;x&#59;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
            </xsl:when>
            <xsl:when test="$Type_noeud='grundstueck:Liegenschaft'">
                        <xsl:choose>
                            <xsl:when test="$Num_PPE_old_style!=''"> <!-- dans ce cas-ci le num de PPE refl�te le num de copropri�t� -->
                                <xsl:value-of select="$Num_cant"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$Num_niv1"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$EGRID"/><xsl:text>&#59;&#59;</xsl:text>
                                <xsl:value-of select="$Num_niv1"/><xsl:text>-</xsl:text><xsl:value-of select="$Num_PPE_old_style"/><xsl:text>&#59;&#59;&#59;x&#59;</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$Num_cant"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$Num_niv1"/><xsl:text>&#59;</xsl:text>
                                <xsl:value-of select="$EGRID"/><xsl:text>&#59;&#59;</xsl:text>
                                <xsl:value-of select="$Num_copro"/><xsl:text>&#59;&#59;&#59;x&#59;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
						
					</xsl:when>
				</xsl:choose>
                
                <xsl:value-of select="$AdresseBF"/><xsl:text>&#59;</xsl:text>
                <!-- Saute la surface -->
                <xsl:text>&#59;</xsl:text>
                
                <!-- Acquisition -->
                <xsl:call-template name="Acquisition">
                    <xsl:with-param name="Date" select="$Date_Acquisition"/>
					<xsl:with-param name="Motif" select="$Motif_Acquisition"/>
				</xsl:call-template>
                
                <!-- Estimation Fiscale -->
                <xsl:call-template name="Affiche_estimation">
					<xsl:with-param name="Valeur" select="$Val_estimation"/>
					<xsl:with-param name="ProtokolNr" select="$Protokol_estimation"/>
                    <xsl:with-param name="ProtokolDate" select="$ProtokolDatum_estimation"/>
				</xsl:call-template>
                
				<xsl:call-template name="Affiche_nom">
					<xsl:with-param name="TypeP" select="$Type_pers"/>
					<xsl:with-param name="IDP" select="$ID_pers"/>
				</xsl:call-template>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>

	</xsl:for-each>

	<!-- pour chaque PPE-->
	<xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:GrundstueckList/grundstueck:StockwerksEinheit">
	
		<xsl:variable name="ID" select="grundstueck:GrundstueckID/text()"/>
    <xsl:variable name="EGRID" select="grundstueck:EGrid/text()"/>
    <xsl:variable name="Num_cant" select="grundstueck:GrundstueckNummer/grundstueck:BfsNr/text()"/>
		<xsl:variable name="Num_PPE" select="grundstueck:GrundstueckNummer/grundstueck:StammNr/text()"/>
		<xsl:variable name="Num_BF" select="grundstueck:StammGrundstueck/grundstueck:BelastetesGrundstueck/grundstueck:GrundstueckNummer/grundstueck:StammNr/text()"/>
    <xsl:variable name="Num_feuillet" select="grundstueck:GrundstueckNummer/grundstueck:IndexNr1/text()"/>
    <xsl:variable name="AdresseBF" select="grundstueck:Sonderrecht/grundstueck:Sonderrecht/text()"/>
    <xsl:variable name="Val_estimation" select="grundstueck:AmtlicheBewertung/grundstueck:AmtlicherWert/text()"/>
    <xsl:variable name="Protokol_estimation" select="grundstueck:AmtlicheBewertung/grundstueck:ProtokollNr/text()"/>
    <xsl:variable name="ProtokolDatum_estimation" select="grundstueck:AmtlicheBewertung/grundstueck:ProtokollDatum/text()"/>
		
		<xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:EigentumList/grundstueck:PersonEigentumAnteil/grundstueck:BelastetesGrundstueckIDREF[.=$ID]">
			
			<xsl:variable name="ID_pers" select="parent::*/*/grundstueck:PersonstammIDREF/text()"/>
			<xsl:variable name="Type_pers" select="name(/grundstueck:GrundstueckExport/grundstueck:PersonstammList/*/grundstueck:PersonstammID[.=$ID_pers]/parent::*)"/>
            <xsl:variable name="Motif_Acquisition" select="parent::*/*/grundstueck:Rechtsgruende[last()]/grundstueck:RechtsgrundCode/grundstueck:TextFr/text()"/>
            <xsl:variable name="Date_Acquisition" select="parent::*/*/grundstueck:Rechtsgruende[last()]/grundstueck:BelegDatum/text()"/>
			
			<xsl:if test="$ID_pers!=''">
            
                    <xsl:choose>
                        <xsl:when test="$Num_feuillet!=''">
                            <xsl:value-of select="$Num_cant"/><xsl:text>&#59;</xsl:text>
                            <xsl:value-of select="$Num_BF"/><xsl:text>&#59;</xsl:text>
                            <xsl:value-of select="$EGRID"/><xsl:text>&#59;</xsl:text>
                            <xsl:value-of select="$Num_PPE"/><xsl:text>-</xsl:text><xsl:value-of select="$Num_feuillet"/><xsl:text>&#59;&#59;&#59;x&#59;&#59;</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$Num_cant"/><xsl:text>&#59;</xsl:text>
                            <xsl:value-of select="$Num_BF"/><xsl:text>&#59;</xsl:text>
                            <xsl:value-of select="$EGRID"/><xsl:text>&#59;</xsl:text>
                            <xsl:value-of select="$Num_PPE"/><xsl:text>&#59;&#59;&#59;x&#59;&#59;</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                
                <!-- Saute l'adresse (multiligne pour les PPE) -->
                <xsl:text>&#59;</xsl:text>
                <!-- Saute la surface -->
                <xsl:text>&#59;</xsl:text>
                
                <!-- Acquisition -->
                <xsl:call-template name="Acquisition">
                    <xsl:with-param name="Date" select="$Date_Acquisition"/>
					<xsl:with-param name="Motif" select="$Motif_Acquisition"/>
				</xsl:call-template>
                
                <!-- Estimation Fiscale -->
                <xsl:call-template name="Affiche_estimation">
					<xsl:with-param name="Valeur" select="$Val_estimation"/>
					<xsl:with-param name="ProtokolNr" select="$Protokol_estimation"/>
                    <xsl:with-param name="ProtokolDate" select="$ProtokolDatum_estimation"/>
				</xsl:call-template>

				<xsl:call-template name="Affiche_nom">
					<xsl:with-param name="TypeP" select="$Type_pers"/>
					<xsl:with-param name="IDP" select="$ID_pers"/>
				</xsl:call-template>
				
			</xsl:if>
		</xsl:for-each>
		
	</xsl:for-each>

	<!-- pour chaque BF-->
	<xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:GrundstueckList/grundstueck:Liegenschaft">
	
		<xsl:variable name="ID" select="grundstueck:GrundstueckID/text()"/>
    <xsl:variable name="EGRID" select="grundstueck:EGrid/text()"/>
    <xsl:variable name="Num_cant" select="grundstueck:GrundstueckNummer/grundstueck:BfsNr/text()"/>
		<xsl:variable name="Num_BF" select="grundstueck:GrundstueckNummer/grundstueck:StammNr/text()"/>
    <xsl:variable name="AdresseBF" select="/grundstueck:GrundstueckExport/grundstueck:GrundstueckAdresseList/grundstueck:GrundstueckAdresse/grundstueck:GrundstueckIDREF[.=$ID]/parent::*/grundstueck:AdresseText/text()"/>
    <xsl:variable name="Val_estimation" select="grundstueck:AmtlicheBewertung/grundstueck:AmtlicherWert/text()"/>
    <xsl:variable name="Protokol_estimation" select="grundstueck:AmtlicheBewertung/grundstueck:ProtokollNr/text()"/>
    <xsl:variable name="ProtokolDatum_estimation" select="grundstueck:AmtlicheBewertung/grundstueck:ProtokollDatum/text()"/>
    <xsl:variable name="Surface" select="grundstueck:GrundstueckFlaeche/grundstueck:Flaeche/text()"/>
		
		<xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:EigentumList/grundstueck:PersonEigentumAnteil/grundstueck:BelastetesGrundstueckIDREF[.=$ID]">
			
			<xsl:variable name="ID_pers" select="parent::*/*/grundstueck:PersonstammIDREF/text()"/>
			<xsl:variable name="Type_pers" select="name(/grundstueck:GrundstueckExport/grundstueck:PersonstammList/*/grundstueck:PersonstammID[.=$ID_pers]/parent::*)"/>
            <xsl:variable name="Motif_Acquisition" select="parent::*/*/grundstueck:Rechtsgruende[last()]/grundstueck:RechtsgrundCode/grundstueck:TextFr/text()"/>
            <xsl:variable name="Date_Acquisition" select="parent::*/*/grundstueck:Rechtsgruende[last()]/grundstueck:BelegDatum/text()"/>
			
			<xsl:if test="$ID_pers!=''">
                <xsl:value-of select="$Num_cant"/><xsl:text>&#59;</xsl:text>
                <xsl:value-of select="$Num_BF"/><xsl:text>&#59;</xsl:text>
                <xsl:value-of select="$EGRID"/><xsl:text>&#59;&#59;&#59;x&#59;&#59;&#59;</xsl:text>

                <xsl:value-of select="$AdresseBF"/><xsl:text>&#59;</xsl:text>
                <!-- Surface -->
                <xsl:value-of select="$Surface"/><xsl:text>&#59;</xsl:text>
                
                <!-- Acquisition -->
                <xsl:call-template name="Acquisition">
                    <xsl:with-param name="Date" select="$Date_Acquisition"/>
					<xsl:with-param name="Motif" select="$Motif_Acquisition"/>
				</xsl:call-template>
                
                
                <!-- Estimation Fiscale -->
                <xsl:call-template name="Affiche_estimation">
					<xsl:with-param name="Valeur" select="$Val_estimation"/>
					<xsl:with-param name="ProtokolNr" select="$Protokol_estimation"/>
                    <xsl:with-param name="ProtokolDate" select="$ProtokolDatum_estimation"/>
				</xsl:call-template>
                    
				<xsl:call-template name="Affiche_nom">
					<xsl:with-param name="TypeP" select="$Type_pers"/>
					<xsl:with-param name="IDP" select="$ID_pers"/>
				</xsl:call-template>
				
			</xsl:if>
		</xsl:for-each>
		
	</xsl:for-each>
	
	<!-- pour chaque DDP-->
  <xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:GrundstueckList/grundstueck:Sdr">
	
		<xsl:variable name="ID" select="grundstueck:GrundstueckID/text()"/>
    <xsl:variable name="EGRID" select="grundstueck:EGrid/text()"/>
    <xsl:variable name="Num_cant" select="grundstueck:GrundstueckNummer/grundstueck:BfsNr/text()"/>
		<xsl:variable name="Num_BF" select="grundstueck:GrundstueckNummer/grundstueck:StammNr/text()"/>
    <xsl:variable name="AdresseBF" select="/grundstueck:GrundstueckExport/grundstueck:GrundstueckAdresseList/grundstueck:GrundstueckAdresse/grundstueck:GrundstueckIDREF[.=$ID]/parent::*/grundstueck:AdresseText/text()"/>
    <xsl:variable name="Val_estimation" select="grundstueck:AmtlicheBewertung/grundstueck:AmtlicherWert/text()"/>
    <xsl:variable name="Protokol_estimation" select="grundstueck:AmtlicheBewertung/grundstueck:ProtokollNr/text()"/>
    <xsl:variable name="ProtokolDatum_estimation" select="grundstueck:AmtlicheBewertung/grundstueck:ProtokollDatum/text()"/>
    <xsl:variable name="Surface" select="grundstueck:GrundstueckFlaeche/grundstueck:Flaeche/text()"/>
		
		<xsl:for-each select="/grundstueck:GrundstueckExport/grundstueck:EigentumList/grundstueck:PersonEigentumAnteil/grundstueck:BelastetesGrundstueckIDREF[.=$ID]">
			
			<xsl:variable name="ID_pers" select="parent::*/*/grundstueck:PersonstammIDREF/text()"/>
			<xsl:variable name="Type_pers" select="name(/grundstueck:GrundstueckExport/grundstueck:PersonstammList/*/grundstueck:PersonstammID[.=$ID_pers]/parent::*)"/>
            <xsl:variable name="Motif_Acquisition" select="parent::*/*/grundstueck:Rechtsgruende[last()]/grundstueck:RechtsgrundCode/grundstueck:TextFr/text()"/>
            <xsl:variable name="Date_Acquisition" select="parent::*/*/grundstueck:Rechtsgruende[last()]/grundstueck:BelegDatum/text()"/>
			
			<xsl:if test="$ID_pers!=''">
                <xsl:value-of select="$Num_cant"/><xsl:text>&#59;</xsl:text>
                <xsl:value-of select="$Num_BF"/><xsl:text>&#59;</xsl:text>
                <xsl:value-of select="$EGRID"/><xsl:text>&#59;&#59;&#59;x&#59;&#59;&#59;</xsl:text>

                <xsl:value-of select="$AdresseBF"/><xsl:text>&#59;</xsl:text>
                <!-- Surface -->
                <xsl:value-of select="$Surface"/><xsl:text>&#59;</xsl:text>
                
                <!-- Acquisition -->
                <xsl:call-template name="Acquisition">
                    <xsl:with-param name="Date" select="$Date_Acquisition"/>
					<xsl:with-param name="Motif" select="$Motif_Acquisition"/>
				</xsl:call-template>

                <!-- Estimation Fiscale -->
                <xsl:call-template name="Affiche_estimation">
					<xsl:with-param name="Valeur" select="$Val_estimation"/>
					<xsl:with-param name="ProtokolNr" select="$Protokol_estimation"/>
                    <xsl:with-param name="ProtokolDate" select="$ProtokolDatum_estimation"/>
				</xsl:call-template>
                    
				<xsl:call-template name="Affiche_nom">
					<xsl:with-param name="TypeP" select="$Type_pers"/>
					<xsl:with-param name="IDP" select="$ID_pers"/>
				</xsl:call-template>
        
			</xsl:if>
      
		</xsl:for-each>
    
	</xsl:for-each>
  
</xsl:template>

<!-- Ici viennent les modeles de colonnes utilises plus haut pour concatener un certain nombre d'informations-->
<xsl:template name="Affiche_nom">

	<xsl:param name="TypeP"/>
	<xsl:param name="IDP"/>
	
	<xsl:variable name="Rue_prop_obj" select="/grundstueck:GrundstueckExport/grundstueck:PersonstammList/*/grundstueck:PersonstammID[.=$IDP]/parent::*/grundstueck:Adressen/grundstueck:Strasse/text()"/>
	<xsl:variable name="NPA_prop_obj" select="/grundstueck:GrundstueckExport/grundstueck:PersonstammList/*/grundstueck:PersonstammID[.=$IDP]/parent::*/grundstueck:Adressen/grundstueck:PLZ/text()"/>
	<xsl:variable name="Loc_prop_obj" select="/grundstueck:GrundstueckExport/grundstueck:PersonstammList/*/grundstueck:PersonstammID[.=$IDP]/parent::*/grundstueck:Adressen/grundstueck:Ort/text()"/>
	<xsl:variable name="Adr_prop_obj" select="concat($Rue_prop_obj,concat(' ',concat($NPA_prop_obj,concat(' ',$Loc_prop_obj))))"/>
	<xsl:choose>
		<xsl:when test="$TypeP='grundstueck:NatuerlichePersonstamm'">
			<xsl:value-of select="concat(/grundstueck:GrundstueckExport/grundstueck:PersonstammList/grundstueck:NatuerlichePersonstamm/grundstueck:PersonstammID[.=$IDP]/parent::*/grundstueck:Name/text(), concat(' ',/grundstueck:GrundstueckExport/grundstueck:PersonstammList/grundstueck:NatuerlichePersonstamm/grundstueck:PersonstammID[.=$IDP]/parent::*/grundstueck:Vorname/text()))"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="/grundstueck:GrundstueckExport/grundstueck:PersonstammList/*/grundstueck:PersonstammID[.=$IDP]/parent::*/grundstueck:Name/text()"/>
		</xsl:otherwise>
	</xsl:choose>
	
	<xsl:text>&#59;</xsl:text>
	<!-- recupere l'adresse -->
	<xsl:copy-of select="$Adr_prop_obj"/><xsl:text>&#xa;</xsl:text>
</xsl:template>

<xsl:template name="Affiche_estimation">

	<xsl:param name="Valeur"/>
	<xsl:param name="ProtokolNr"/>
  <xsl:param name="ProtokolDate"/>
  
   <xsl:choose>
       <xsl:when test="$ProtokolDate!=''">
              <xsl:variable name="Estimation" select="concat($Valeur,concat(' CHF, ',concat($ProtokolNr,concat(' du ',$ProtokolDate))))"/>
              <xsl:copy-of select="$Estimation"/>
      </xsl:when>
      <xsl:otherwise>
              <xsl:variable name="Estimation" select="concat($Valeur,concat(' CHF, ',concat($ProtokolNr,'')))"/>
              <xsl:copy-of select="$Estimation"/>
      </xsl:otherwise>
   </xsl:choose>

  <xsl:text>&#59;</xsl:text>

</xsl:template>

<xsl:template name="Acquisition">

	<xsl:param name="Date"/>
	<xsl:param name="Motif"/>
	
     <xsl:copy-of select="$Date"/><xsl:text>&#59;</xsl:text><xsl:copy-of select="$Motif"/><xsl:text>&#59;</xsl:text>

</xsl:template>

</xsl:stylesheet>