<!--
   Licensed to the Apache Software Foundation (ASF) under one
   or more contributor license agreements.  See the NOTICE file
   distributed with this work for additional information
   regarding copyright ownership.  The ASF licenses this file
   to you under the Apache License, Version 2.0 (the
   "License"); you may not use this file except in compliance
   with the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing,
   software distributed under the License is distributed on an
   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
   KIND, either express or implied.  See the License for the
   specific language governing permissions and limitations
   under the License.
-->
<xsl:stylesheet
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  exclude-result-prefixes="df xs relpath htmlutil xd dc"
  version="2.0">

  <xsl:import href="map2boostrapNav.xsl" />


  <xsl:template mode="toc-title" match="*[df:isTopicRef(.)] | *[df:isTopicHead(.)]">
    <xsl:variable name="titleValue" select="df:getNavtitleForTopicref(.)"/>
    <xsl:sequence select="$titleValue"/>
  </xsl:template>

  <!-- FIXME: Replace this with a separate mode that will handle markup within titles -->
  <xsl:template mode="gen-head-title" match="*">
    <xsl:param name="documentation-title" as="xs:string" select="''" tunnel="yes" />
    <xsl:param name="topic-title" as="xs:string" select="''" tunnel="yes" />

    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="*[df:class(., 'topic/title')][1]">
          <xsl:value-of select="*[df:class(., 'topic/title')][1]" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$documentation-title" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <title><xsl:value-of select="normalize-space($title)" /></title>
  </xsl:template>


  <xsl:template match="*" mode="generate-html5-page">
    <html>
      <xsl:attribute name = "lang" select="$TEMPLATELANG" />
      <xsl:apply-templates select="." mode="generate-head"/>
      <xsl:apply-templates select="." mode="generate-body"/>
    </html>
  </xsl:template>

  <!-- page links are intented to be used for screen reader -->
  <xsl:template name="gen-page-links">
    <div id="page-links">
      <a id="skip-to-content" href="#{$IDMAINCONTENT}">
            <xsl:call-template name="getString">
              <xsl:with-param name="stringName" select="'SkipToContent'"/>
            </xsl:call-template>
          </a>
      <a id="skip-to-localnav" href="#local-navigation">
            <xsl:call-template name="getString">
              <xsl:with-param name="stringName" select="'SkipToLocalNav'"/>
            </xsl:call-template>
      </a>
      <a id="skip-to-footer" href="#footer">
            <xsl:call-template name="getString">
              <xsl:with-param name="stringName" select="'SkipToFooter'"/>
            </xsl:call-template>
      </a>
    </div>
  </xsl:template>

  <!-- define class attribute -->
  <xsl:template match="*" mode="set-body-class-attr">
    <xsl:param name="is-root" as="xs:boolean"  tunnel="yes" select="false()" />
    <xsl:attribute name = "class">
      <xsl:call-template name="getLowerCaseLang"/>
        <xsl:sequence select="' '"/>
        <xsl:value-of select="$siteTheme" />
        <xsl:sequence select="' '"/>
        <xsl:value-of select="$BODYCLASS" />
        <xsl:apply-templates select="." mode="gen-user-body-class"/>
        <xsl:if test="$is-root">
          <xsl:sequence select="' '"/>
          <xsl:value-of select="$CLASSHOMEPAGE"/>
        </xsl:if>
    </xsl:attribute>
  </xsl:template>

  <!-- used to defined initial content if javascript is off -->
  <xsl:template match="*" mode="set-initial-content">
    <noscript>
      <p>
        <xsl:call-template name="getString">
          <xsl:with-param name="stringName" select="'turnJavascriptOn'"/>
        </xsl:call-template>
      </p>
    </noscript>
  </xsl:template>

  <!-- used to output the html5 header -->
  <xsl:template match="*" mode="generate-header">
    <xsl:param name="documentation-title" as="xs:string" select="''" tunnel="yes" />
    <header id="site-head" class="header header--fixed">
      <nav id="topNav" class="navbar navbar-inverse navbar-static-top" role="navigation">
        <div class="container">
          <!--div class="navbar-header">
          <a class="navbar-brand" href="#">
            <img alt="Brand" src="...">
          </a>
        </div-->
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#"><xsl:value-of select="$documentation-title" /></a>

        </div>

        <xsl:call-template name="gen-search-box" />

        <ul class="nav navbar-nav navbar-right hidden-xs">
          <li id="dropdown-share" class="dropdown share">
            <a href="#" class="dropdown-toggle  btn-lg btn" data-toggle="dropdown" role="button" aria-expanded="false"><span class="fa  fa-share-alt"></span><span class="sr-only">Share</span><span class="caret"></span></a>
            <ul class="dropdown-menu" role="menu">
              <li><a id="LinkFacebook" href="https://www.facebook.com/"><span class="fa fa-facebook"></span> Facebook</a></li>
              <li><a id="LinkLinkedin" href="https://www.linkedin.com/"><span class="fa fa-linkedin"></span> LinkedIn</a></li>
              <li><a id="LinkTwitter" href="https://twitter.com/?lang=en"><span class="fa fa-twitter"></span> Tweeter</a></li>
            </ul>
          </li>
          <!--li class="dropdown">
            <a href="#" class="dropdown-toggle btn-lg btn" data-toggle="dropdown" role="button" aria-expanded="false">
              <span class="fa fa-download"></span><span class="sr-only">Download</span><span class="caret"></span>
            </a>
                <ul class="dropdown-menu" role="menu">
                  <li><a href="#">PDF</a></li>
                  <li><a href="#">Epub</a></li>
                </ul>
              </li-->
            </ul>
          </div><!--/.nav-collapse -->

          <div id="navbar" class="navbar-collapse collapse" aria-expanded="true">
            <xsl:call-template name="header-navigation"/>
          </div>


      </nav>
      <div id="msg-version"></div>
    </header>

  </xsl:template>




  <xsl:template name="gen-search-box">
    <form id="search" class="navbar-form navbar-right hidden-xs" role="search">
      <div class="form-group">
        <input id="search-text" type="text" class="form-control" placeholder="Search"/>
      </div>
    </form>
  </xsl:template>

  <!-- used to output the head -->
  <xsl:template match="*" mode="generate-head">
    <head>
      <xsl:apply-templates select="." mode="gen-head-title" />
      <xsl:apply-templates select="." mode="gen-user-top-head" />

      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
      <!-- Dublin core metadata, schema -->
      <link rel="schema.DC" href="http://purl.org/dc/terms/" />
      <xsl:call-template name="getMeta"/>
      <xsl:call-template name="copyright"/>
      <xsl:apply-templates select="." mode="generate-css-js"/>
      <xsl:apply-templates select="." mode="gen-user-bottom-head" />
    </head>
  </xsl:template>

  <!-- generate body -->
  <xsl:template match="*" mode="generate-body">
    <xsl:param name="map-metadata" as="element()*" tunnel="yes" />
    <body data-spy="scroll" data-target="#side-navigation">
      <xsl:apply-templates select="." mode="set-body-class-attr" />
      <xsl:apply-templates select="." mode="generate-main-container"/>
    </body>
  </xsl:template>

  <!-- main content -->
  <xsl:template match="*" mode="generate-main">
    <xsl:param name="is-root" as="xs:boolean"  tunnel="yes" select="false()" />
    <xsl:param name="navigation" as="element()*"  tunnel="yes" />
    <div>
      <xsl:attribute name="class"><xsl:value-of select="concat('page', ' ', name(.), ' ', @outputclass, ' ', replace(replace(@class, '/', '-'), ' - ', ' '))" /></xsl:attribute>

      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
      </xsl:if>

      <!-- Already put xml:lang on <html>; do not copy to body with commonattributes -->
      <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]/@outputclass" mode="add-ditaval-style"/>
      <xsl:value-of select="$newline"/>

      <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>

      <xsl:if test="$INDEXSHOW='yes'">
        <xsl:apply-templates select="/*/*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/keywords ')]/*[contains(@class,' topic/indexterm ')] |
          /dita/*[1]/*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/keywords ')]/*[contains(@class,' topic/indexterm ')]"/>
      </xsl:if>

      <!-- Include a user's XSL call here to generate a toc based on what's a child of topic -->
      <xsl:call-template name="gen-user-sidetoc"/>
      <xsl:choose>
        <xsl:when test="$is-root">
            <h1><xsl:call-template name="getString">
              <xsl:with-param name="stringName" select="'TOC'"/>
            </xsl:call-template></h1>
             <xsl:sequence select="$navigation"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="*" />
        </xsl:otherwise>
      </xsl:choose>

      <xsl:call-template name="gen-endnotes"/>    <!-- include footnote-endnotes -->

      <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    </div>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <!-- generate main container -->
  <xsl:template match="*" mode="generate-main-container">
      <xsl:call-template name="gen-page-links" />
      <xsl:apply-templates select="." mode="generate-header"/>
      <xsl:apply-templates select="." mode="generate-section-container"/>
      <xsl:apply-templates select="." mode="generate-footer"/>
  </xsl:template>

  <!-- generate section container -->
  <xsl:template match="*" mode="generate-section-container">
    <xsl:param name="navigation" as="element()*"  tunnel="yes" />
    <xsl:param name="is-root" as="xs:boolean"  tunnel="yes" select="false()" />
    <xsl:param name="resultUri" as="xs:string" tunnel="yes" select="''" />

    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-md-21">
          <ol class="breadcrumb">
            <xsl:call-template name="inline-breadcrumbs"/>
            <xsl:call-template name="breadcrumbs-format-links">
              <xsl:with-param name="title" select="df:getNavtitleForTopic(.)" as="xs:string" />
              <xsl:with-param name="href" select="''" as="xs:string" />
            </xsl:call-template>
          </ol>
        </div>
      </div>

      <div class="row">

        <xsl:if test="$navigationLeftBoolean">
          <div class="col-xs-6 col-md-4 hidden-xs">
            <xsl:call-template name="navigation"/>
          </div>
        </xsl:if>

        <div class="col-xs-12 col-md-8">
          <xsl:apply-templates select="." mode="generate-main-content"/>
        </div>

        <xsl:if test="$navigationLeftBoolean = false()">
          <div class="col-xs-6 col-md-4">
            <xsl:call-template name="navigation"/>
          </div>
        </xsl:if>

      </div>
    </div>
  </xsl:template>


   <xsl:template name="breadcrumbs-format-links">
    <xsl:param name="title" as="xs:string" />
    <xsl:param name="href" as="xs:string" />
     <li>
       <xsl:choose>
         <xsl:when test="$href != ''">
           <a class="breadcrumb" href="{$href}" title="{$title}">
             <xsl:sequence select="$title" />
           </a>
         </xsl:when>
         <xsl:otherwise>
           <xsl:sequence select="$title" />
         </xsl:otherwise>
        </xsl:choose>
     </li>
  </xsl:template>

  <xsl:template name="formatSiblingTopicLinks">
    <xsl:param name="href" as="xs:string"/>
    <xsl:param name="role" as="xs:string"/>
    <xsl:param name="title" as="xs:string"/>

    <xsl:choose>
     <xsl:when test="$role = 'next'">
        <a href="{$href}" class="{$role}" rel="internal" title="{$title}"><span class="sr-only"><xsl:value-of select="$title"/></span><span class="fa fa-arrow-circle-o-right"></span></a>
     </xsl:when>
     <xsl:when test="$role = 'previous'">
        <a href="{$href}" class="{$role}" rel="internal" title="{$title}"><span class="fa fa-arrow-circle-o-left"></span><span class="sr-only"><xsl:value-of select="$title"/></span></a>
     </xsl:when>
     <xsl:when test="$role = 'parent'">
        <a href="{$href}" class="{$role}" rel="internal" title="{$title}"><span class="fa fa-arrow-circle-o-up"></span><span class="sr-only"><xsl:value-of select="$title"/></span></a>
     </xsl:when>
     <xsl:otherwise>
         <a href="{$href}" class="{$role}" rel="internal" title="{$title}"><xsl:value-of select="$title"/></a>
     </xsl:otherwise>

    </xsl:choose>

  </xsl:template>

   <!-- generate main content -->
  <xsl:template match="*" mode="generate-main-content">
    <xsl:param name="is-root" as="xs:boolean"  tunnel="yes" select="false()" />
    <xsl:param name="content" tunnel="yes" />
    <div id="page" class="starter-template">
      <article>
        <xsl:choose>
          <xsl:when test="$content">
            <div id="topic-content">
              <xsl:sequence select="$content" />
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="generate-main"/>
            <div class="row">
              <xsl:apply-templates select="." mode="generate-previous-next-topic-links"/>
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </article>
      <div class="clear" /><xsl:sequence select="'&#x0a;'"/>
    </div>
  </xsl:template>

 <!-- generate html5 footer -->
  <xsl:template match="*" mode="generate-breadcrumb">
    <xsl:param name="is-root" as="xs:boolean"  tunnel="yes" select="false()" />
    <xsl:choose>
      <xsl:when test="$is-root">
      </xsl:when>
      <xsl:otherwise>
        <div id="content-toolbar" class="toolbar hide-for-small">
          <xsl:if test="contains($include.roles, ' next ') or contains($include.roles, ' previous ') or contains($include.roles, ' parent ')">
            <xsl:call-template name="next-prev-parent-links"/><!--handle next and previous links-->
          </xsl:if>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

   <!-- generate html5 footer -->
  <xsl:template match="*" mode="generate-inline-breadcrumbs">
    <xsl:param name="is-root" as="xs:boolean"  tunnel="yes" select="false()" />
    <xsl:comment>generate-inline-breadcrumbs</xsl:comment>
    <xsl:choose>
      <xsl:when test="$is-root">
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="inline-breadcrumbs"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <!-- generate html5 footer -->
  <xsl:template match="*" mode="generate-footer">

  </xsl:template>


  <!--
      flag
   -->
  <xsl:template match="*" mode="flag" />

  <xsl:template match="*[contains(@class, ' topic/data ')][@name='version']" mode="flag">
    <div id="flag-version">
      <xsl:value-of select="@value" />
    </div>
  </xsl:template>

</xsl:stylesheet>
