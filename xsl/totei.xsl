<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <xsl:variable name="fname" select=".//FNAME"/>
        <xsl:variable name="volume" select="tokenize($fname, '-')[2]"/>
        <xsl:variable name="issue" select="tokenize($fname, '-')[3]"/>
        <xsl:variable name="page" select="tokenize($fname, '_')[2]"/>
        
        <xsl:variable name="year">
            <xsl:choose>
                <xsl:when test=".//PUBL_YEAR">
                    <xsl:value-of select=".//PUBL_YEAR"/>
                </xsl:when>
                <xsl:otherwise>2000</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="month">
            <xsl:choose>
                <xsl:when test=".//PUBL_MONTH">
                    <xsl:value-of select=".//PUBL_MONTH"/>
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="day">
            <xsl:choose>
                <xsl:when test=".//PUBL_DAY">
                    <xsl:try select="format-number(.//PUBL_DAY[1]/text(), '00')">
                        <xsl:catch select="'01'"></xsl:catch>
                    </xsl:try>
                    
                        
                </xsl:when>
                <xsl:otherwise>01</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="writtenDate">
            <xsl:value-of select="string-join(.//PUBL_DATE//text(), ' ')"/>
        </xsl:variable>
        
        <xsl:variable name="pubDate">
                <xsl:value-of select="format-number($year, '0000')"/>-<xsl:value-of select="format-number($month, '00')"/>-<xsl:value-of select="$day"/>
        </xsl:variable>
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$fname}">
            <xsl:if test=".//PREV">
                <xsl:attribute name="prev">
                    <xsl:value-of select=".//PREV"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".//NEXT">
                <xsl:attribute name="next">
                    <xsl:value-of select=".//NEXT"/>
                </xsl:attribute>
            </xsl:if>
            
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title level="a">
                            <xsl:value-of select=".//DISP/@expl"/>
                        </title>
                        <title level="j">Der Brenner</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <biblStruct type="journal">
                            <analytic>
                                <title>Der Brenner, <xsl:value-of select=".//DISP/@expl"/></title>
                            </analytic>
                            <monogr>
                                <title level="j" ref="https://d-nb.info/gnd/4149123-3">Der Brenner</title>
                                <imprint>
                                    <biblScope unit="volume" n="{$volume}">
                                        <xsl:value-of select=".//DISP/@volume"/>
                                    </biblScope>
                                    <biblScope unit="issue" n="{$issue}">
                                        <xsl:choose>
                                            <xsl:when test=".//DISP/@issue">
                                                <xsl:value-of select=".//DISP/@issue"/>
                                            </xsl:when>
                                            <xsl:otherwise>[1]</xsl:otherwise>
                                        </xsl:choose>
                                    </biblScope>
                                    <biblScope unit="page" n="{$page}">
                                        <xsl:value-of select=".//DISP/@page"/>
                                    </biblScope>
                                    <pubPlace ref="https://sws.geonames.org/2775216/">Innsbruck</pubPlace>
                                    <publisher ref="https://d-nb.info/gnd/118532871">Ficker, Ludwig von</publisher>
                                    <date when-iso="{$pubDate}"><xsl:value-of select="$writtenDate"/></date>
                                </imprint>
                            </monogr>
                        </biblStruct>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <div type="page">
                        <xsl:apply-templates/>
                    </div>
                </body>
            </text>
        </TEI>
    </xsl:template>
    
    <xsl:template match="TABLE">
        <table>
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    
    <xsl:template match="ROW">
        <row>
            <xsl:apply-templates/>
        </row>
    </xsl:template>
    <xsl:template match="CELL">
        <cell>
            <xsl:apply-templates/>
        </cell>
    </xsl:template>
    
    <xsl:template match="DIV_START">
        <milestone>
            <xsl:if test="./@par">
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="./@parid"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="./@itemCnt">
                <xsl:attribute name="n">
                    <xsl:value-of select="./@itemCnt"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="unit">
                <xsl:choose>
                    <xsl:when test="./@type">
                        <xsl:value-of select="./@type||'-start'"/>
                    </xsl:when>
                    <xsl:when test="./@cat">
                        <xsl:value-of select="./@cat||'-start'"/>
                    </xsl:when>
                    <xsl:otherwise>untyped-start</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </milestone>
    </xsl:template>
    
    <xsl:template match="DIV_END">
        <milestone>
            <xsl:attribute name="unit">
                <xsl:choose>
                    <xsl:when test="./@type">
                        <xsl:value-of select="./@type||'-end'"/>
                    </xsl:when>
                    <xsl:when test="./@cat">
                        <xsl:value-of select="./@cat||'-end'"/>
                    </xsl:when>
                    <xsl:otherwise>untyped-end</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </milestone>
    </xsl:template>
    
    <xsl:template match="IMG">
        <figure>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="./@type">
                        <xsl:value-of select="./@type"/>
                    </xsl:when>
                    <xsl:otherwise>image</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="./@itemCnt">
                <xsl:attribute name="n">
                    <xsl:value-of select="./@itemCnt"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </figure>
    </xsl:template>
    
    <xsl:template match="HR">
        <milestone unit="hr"/>
    </xsl:template>
    
    <xsl:template match="SIGNATURE">
        <ab type="signatur">
            <xsl:if test="./@parid">
                <xsl:attribute name="xml:id"><xsl:value-of select="./@parid"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </ab>
    </xsl:template>
    
    <xsl:template match="AUCTOR">
        <rs type="person" ref="{'#'||@globID}"><xsl:apply-templates/></rs>
    </xsl:template>
    
    <xsl:template match="NAME">
        <rs type="person" ref="{'#'||@globID}"><xsl:apply-templates/></rs>
    </xsl:template>
    
    <xsl:template match="w">
        <w><xsl:apply-templates/></w>
    </xsl:template>
    
    <xsl:template match="NAV_HEADER"/>
    
    <xsl:template match="P">
        <p>
            <xsl:if test="./@par">
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="./@parid"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="FN">
        <note type="footnote">
            <xsl:apply-templates/>
        </note>
    </xsl:template>
    
    <xsl:template match="LE">
        <lb />
    </xsl:template>

    <xsl:template match="//LE[following-sibling::*[1][self::HYPH2]]">
        <lb break="no"/>
    </xsl:template>
    
    <xsl:template match="ABBR">
        <abbr xml:id="{./@abbrID}"><xsl:apply-templates/></abbr>
    </xsl:template>
    
    <xsl:template match="I">
        <hi rend="italics"><xsl:apply-templates/></hi>
    </xsl:template>
    
    <xsl:template match="B">
        <hi rend="strong"><xsl:apply-templates/></hi>
    </xsl:template>
    <xsl:template match="AQ">
        <hi rend="text-spaced"><xsl:apply-templates/></hi>
    </xsl:template>
    
    <xsl:template match="TITLE">
        <ab>
            <title><xsl:apply-templates/></title>
        </ab>
    </xsl:template>
    
    <xsl:template match="HD">
        <fw>
            <xsl:apply-templates/>
        </fw>
    </xsl:template>
    
    <xsl:template match="TABLE/TITLE">
        <head>
            <xsl:apply-templates/>
        </head>
    </xsl:template>
    
    <xsl:template match="LINK[./text()]">
        <ref target="{./@href}">
            <xsl:apply-templates/>
        </ref>
    </xsl:template>
    
    <xsl:template match="LG">
        <lg><xsl:apply-templates/></lg>
    </xsl:template>
    
    <xsl:template match="L">
        <l><xsl:apply-templates/></l>
    </xsl:template>
    
    <xsl:template match="P//LABEL">
        <seg type="label">
            <xsl:if test="./@rend">
                <xsl:attribute name="rend"><xsl:value-of select="./@rend"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </seg>
    </xsl:template>
    <xsl:template match="P//FIELD">
        <seg type="label">
            <xsl:if test="./@rend">
                <xsl:attribute name="rend"><xsl:value-of select="./@rend"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </seg>
    </xsl:template>
    
    <xsl:template match="LABEL">
        <ab type="label">
            <xsl:if test="./@rend">
                <xsl:attribute name="rend"><xsl:value-of select="./@rend"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </ab>
    </xsl:template>
    <xsl:template match="FIELD">
        <ab type="label">
            <xsl:if test="./@rend">
                <xsl:attribute name="rend"><xsl:value-of select="./@rend"/></xsl:attribute>
            </xsl:if><xsl:apply-templates/></ab>
    </xsl:template>
    
    <xsl:template match="PAGE/text()">
        <xsl:if test="normalize-space(.)">
            <ab type="catchall">
                <xsl:value-of select="normalize-space(.)"/>
            </ab>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="PAGE/AUCTOR">
        <ab type="orphaned_author"><rs type="person" ref="{'#'||@globID}"><xsl:apply-templates/></rs></ab>
    </xsl:template>

</xsl:stylesheet>