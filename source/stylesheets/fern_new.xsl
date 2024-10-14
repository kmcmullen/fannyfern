<?xml version="1.0" encoding="UTF-8"?>
<!-- STYLESHEET FOR THE 2nd VERSION OF THE FANNY FERN SITE; CREATED 2014 BY KEVIN MCMULLEN. -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="html" indent="no" encoding="utf-8" media-type="text/html" 
        doctype-public="-//W3C//DTD HTML 4.0//EN"/><!-- setting indent to "no" causes no linebreaks to appear in the output HTML, because Drupal automatically encodes hard linebreaks for any soft linebreaks in the text. Stupid Drupal... -->
    
    <!-- Master Template Begins Here-->
    

    <xsl:template match="/">
        <!--<head>
            <link rel="stylesheet" type="text/css" href="http://iamkevinmcmullen.com/fern/stylesheets/fern_new.css"/>
        </head>-->
        <!-- CSS link is not needed, because the page is being styled by the CSS within the Drupal theme -->
        
        
        
        <body>
            
            <div class="content">
                
                <h1 class="pageTitle"><xsl:value-of select="//sourceDesc//date"/></h1>
                <xsl:call-template name="images"/>
                <xsl:apply-templates select="//body"/>
           
            </div>
            
            <xsl:if test="//div[@type='notes']">
                <div class="notes">
                    <h6>Editorial Notes:</h6>
                    <xsl:apply-templates select="//back"/>
                </div>
            </xsl:if>
            
            <div class="citation">
                <xsl:call-template name="citation"/>
            </div>
            <div class="report">
                <h6 class="report"><a href="http://fannyfern.org/contact" target="_blank">Report corrections</a></h6>
            </div>
            <div class="xmlDownload">
                <xsl:call-template name="xmlDownload"/>
            </div>
            
            
        </body>
     
        
    </xsl:template>
    <!-- End of Master Template -->
    
    <!-- various templates for dealing with the styling of titles, dates, headers, bylines, quotes, etc. -->
    <xsl:template name="title">
             <xsl:value-of select="//titleStmt[1]/title[1]"/>
    </xsl:template>
    
    <xsl:template name="date">
        <xsl:value-of select="//sourceDesc//date"/>
    </xsl:template>
  
    <xsl:template match="text//head[@type='column']">
        <h1 class="columnHead"><xsl:apply-templates/></h1>
    </xsl:template>
    
    <xsl:template match="text//head[@type='main']">
        <h2 class="columnTitle"><xsl:apply-templates/></h2>
    </xsl:template>
    
    <xsl:template match="text//head[@type='sub']">
        <h3 class="columnSubHead"><xsl:apply-templates/></h3>
    </xsl:template>
        
    <xsl:template match="byline">
        <h5 class="byline"><xsl:apply-templates/></h5>
    </xsl:template>
    
    <xsl:template match="dateline">
        <xsl:choose>
            <xsl:when test="parent::div[@type='letter']"><p class="letter_dateline"><xsl:apply-templates/></p></xsl:when>
            <xsl:otherwise><p class="dateline"><xsl:apply-templates/></p></xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xsl:template match="signed">
        <xsl:choose>
            <xsl:when test="parent::div[@type='letter']"><p class="letter_byline"><xsl:apply-templates/></p></xsl:when>
            <xsl:otherwise><p class="signed"><xsl:apply-templates/></p></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="salute">
        <p class="salutation"><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="q">
        <blockquote><xsl:apply-templates/></blockquote>
    </xsl:template>
    
    <!-- places line-groups (poems) into a special div. -->
    <xsl:template match="lg">
                <div class="poem">
                    <xsl:apply-templates/>
                </div>
    </xsl:template>
    
    <xsl:template match="l">
        <xsl:choose>
            <xsl:when test="@rend='epigraph'">
                <p class="epigraphPoetryLine"><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:otherwise>
                <span class="line"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>  
    </xsl:template>
    
        <xsl:template match="milestone[@unit='line']">
        <hr class="column_divider"/>
    </xsl:template>
    
    <xsl:template match="milestone[@unit='asterisks']">
        <span class="asterisks">*&#32;*&#32;*&#32;*&#32;*&#32;*&#32;*&#32;*&#32;*</span>
    </xsl:template>
    
    <!-- The following three templates suppress corrected or regularized words, or abbreviations that have been expanded, that have been marked in the encoding -->
    <xsl:template match="choice/corr"/>
    <xsl:template match="choice/reg"/>
    <xsl:template match="choice/expan"/>
       
    <!-- places letters that appear in the body of a column in a special div. -->
    <xsl:template match="div[@type='letter']">
        <div class="letter">
           <xsl:apply-templates/>      
        </div>
    </xsl:template>
    
      
    <xsl:template match="lb">
        <br/>
    </xsl:template>
    
    <xsl:template match="gap"><strong>[Missing text (<xsl:value-of select="@reason"/>)]</strong><xsl:apply-templates/></xsl:template>
    
    <!-- at the moment, this is only styling a byline that appears in an epigraph. If more <ab>s are needed later on though, this <xsl:choose> can be expanded. -->
    <xsl:template match="ab">
        <xsl:choose>
            <xsl:when test="@type='epigraphByline'">
                <p class="epigraph_byline"><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- template that puts all paragraphs within epigraphs, footnotes, and letters within a column into a special <h4> or <p>, and puts all other paragraphs into simple <p> tags. -->
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="parent::epigraph"><h4><span class="epigraph"><xsl:apply-templates/></span></h4></xsl:when>
            <xsl:when test="parent::note[@type='footnote']"><h4><span class="footnote"><xsl:apply-templates/></span></h4></xsl:when>
            <xsl:when test="parent::div[@type='letter']"><p class="letter"><xsl:apply-templates/></p></xsl:when>
            <xsl:when test="@rend='center'"><p class="center"><xsl:apply-templates/></p></xsl:when>
            <xsl:otherwise><p class="body_paragraph"><xsl:apply-templates/></p></xsl:otherwise>
        </xsl:choose>
     </xsl:template>
    
    <!-- template for dealing with items encoded in a <hi> tag (italics, underlines, superscripts, etc.) -->
    <xsl:template match="hi">
        <xsl:choose>
            <xsl:when test="./attribute::rend='superscript'">
                <sup><xsl:apply-templates/></sup>
            </xsl:when>
            <xsl:when test="./attribute::rend='italic'">
                <i><xsl:apply-templates/></i>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- template for converting the image names in the <facsimile> element of the XML into image links and thumbnails in the HTML -->
    <xsl:template name="images">
        <xsl:for-each select="//facsimile/surface/graphic"><!-- matching to the correct element in the XML -->
            <xsl:variable name="url"><!-- creating a variable called 'url' -->
                <xsl:value-of select="@url"/><!-- selecting the value of the 'url' attribute (@) in the XML and using that as the value of our newly-created variable -->
            </xsl:variable>
            
            <xsl:element name="a"><!-- creating an <a> element in the HTML -->
                <xsl:attribute name="class">image</xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:value-of select="(concat('http://fannyfern.org/images/', $url))"/><!-- after creating an 'href' attribute, we set it's value as the file-path for our image, concatenating (splicing together) the site URL with the variable that we created above -->
                </xsl:attribute>
                <xsl:attribute name="target">blank</xsl:attribute>
                <!--<xsl:choose>
                    <xsl:when test="parent::surface[@type='containsColumn']">
                        <xsl:attribute name="class">containsColumn image</xsl:attribute> 
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>-->
                
                <xsl:element name="img"><!-- creating an <img> element in the HTML -->
                    <xsl:attribute name="src">
                        <xsl:value-of select="(concat('http://fannyfern.org/images/thumbs/', $url))"/><!-- after creating a 'src' attribute, we set it's value as the file-path of our thumbnail image, which we get by concatenating (splicing together) the site URL and the variable we created -->
                    </xsl:attribute>
                    <xsl:attribute name="width">
                        <xsl:value-of select="'75'"/><!-- setting the width of the thumbnails -->
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="parent::surface[@type='containsColumn']">
                            <xsl:attribute name="class">containsColumn</xsl:attribute> 
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="class">noColumn</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                </xsl:element>
                
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <!-- template for creating the citation that appears at the bottom of each column. The template is created here, and then called in the appropriate place up above in the "Master Template" (following the body text of the column). -->
    <xsl:template name="citation" match="//sourceDesc/biblStruct">
        <h6>Source Text:</h6>
        <p class="citation"><xsl:value-of select="//analytic/author"/>, "<xsl:value-of select="//analytic/title[@level='a']"/>,"<xsl:text> </xsl:text><em><xsl:value-of select="//monogr/title[@level='j']"/></em> (<xsl:value-of select="//sourceDesc/biblStruct[1]/monogr[1]/imprint[1]/date[1]"/>): <xsl:value-of select="//monogr/biblScope[@type='pp']"/><xsl:if test="//biblScope[@type='column']">, column <xsl:value-of select="//monogr/biblScope[@type='column']"/></xsl:if></p>
        <xsl:if test="//sourceDesc/biblStruct/note[@type='editorial_images']">
            <h6>Image credit:</h6>
            <p><xsl:value-of select="//sourceDesc/biblStruct/note[@type='editorial_images']"/>: <xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="//sourceDesc/biblStruct/note/@target"/></xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute><xsl:value-of select="//sourceDesc/biblStruct/note/@target"/></xsl:element></p>
        </xsl:if>
        <h6>To cite this project:</h6>
        <p class="citation"><xsl:value-of select="//analytic/author"/>, "<xsl:value-of select="//analytic/title[@level='a']"/>,"<xsl:text> </xsl:text><em>Fanny Fern in The New York Ledger,</em> Ed. Kevin McMullen (2024) http://fannyfern.org.</p>
        <h6>Contributors to the digital file:</h6>
        <p class="citation">
            <!-- Note: The follow "for-each" was borrowed from the Whitman journalism stylesheet. KM -->
            <xsl:for-each select="TEI/teiHeader/fileDesc/titleStmt/respStmt/persName">
            <xsl:variable name="count" select="count(//persName)"/>
            <xsl:choose>
                <xsl:when test="following-sibling::persName and $count &gt; 2">
                    <xsl:apply-templates/><xsl:text>, </xsl:text></xsl:when>
                <xsl:when test="following-sibling::persName and $count = 2">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:when test="preceding-sibling::persName and not(following-sibling::persName)">
                    <xsl:text> and </xsl:text><xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        </p>
    </xsl:template>
    
    <!-- template creating a box for editorial footnotes, formatted like the box for the citation. -->
    <!--<xsl:template name="editorial_notes">
        <h6>Editorial Notes:</h6>
        <xsl:for-each select="//note[@type='editorial']">
           <p class="citation"><xsl:value-of select="@n"/> <xsl:apply-templates/></p>
            
        </xsl:for-each>
    </xsl:template>-->
    
    
    
    <!-- template creating the "Download source XML" link in the HTML, based off of the xml:id in the TEI element. -->
    <xsl:template name="xmlDownload">
        <xsl:variable name="href">
            <xsl:value-of select="//TEI/@xml:id"/>
        </xsl:variable>
        <xsl:element name="h6">
            <xsl:attribute name="class">xmlDownload</xsl:attribute>
       <xsl:element name="a">
           <xsl:attribute name="href">
               <xsl:value-of select="(concat('https://github.com/kmcmullen/fannyfern/tree/main/source/tei_published', $href, '.xml'))"/>
           </xsl:attribute>
           <xsl:attribute name="download">
               <xsl:value-of select="$href"/>.xml</xsl:attribute>
           Download source XML
       </xsl:element>
        </xsl:element>
    </xsl:template>
    
    
    <!-- template for creating an <img> tag (with appropriate attributes) from graphics within a column. -->
    <xsl:template match="//figure/graphic">
        <xsl:element name="img">
            <xsl:attribute name="src"><xsl:value-of select="@url"/></xsl:attribute>
            <xsl:attribute name="alt"><xsl:value-of select="//figDesc"/></xsl:attribute><!-- puts the info from "figDesc" into the "alt" attribute -->
            <xsl:attribute name="class">inColumn</xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <!-- template that suppresses the figure-description for graphics; that info appears in the "alt" attribute of the <img> tag (see previous template). -->
    <xsl:template match="//figure/figDesc"/>
    
    <!-- creates a superscript number for each footnote pointer -->
    <xsl:template match="//ptr">
        <sup><xsl:value-of select="@n"/></sup>
    </xsl:template>
    
    
    <!-- Deals with editorial footnotes. -->
    <xsl:template match="//note[@type='editorial']">

            <xsl:for-each select=".">
                <p><xsl:value-of select="@n"/>.&#160;<xsl:apply-templates/></p>
            </xsl:for-each>
        
    </xsl:template>
    
    <!-- Deals with links to other columns within the Fanny Fern website (mostly in editorial notes) -->
    <xsl:template match="//ref[@type='internal']">
        <xsl:element name="a">
            <xsl:attribute name="href">http://fannyfern.org/columns/<xsl:value-of select="@target"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
        
    
       
    
  
    
    
    
    
</xsl:stylesheet>