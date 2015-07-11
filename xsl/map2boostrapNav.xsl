<?xml version="1.0" encoding="utf-8"?>
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
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:glossdata="http://dita4publishers.org/glossdata"
  xmlns:mapdriven="http://dita4publishers.org/mapdriven"
  xmlns:enum="http://dita4publishers.org/enumerables"
  xmlns:local="urn:functions:local"
  exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms mapdriven glossdata enum">


  <xsl:template mode="generate-html5-nav-page-markup" match="*[df:class(., 'map/map')]">
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>
    <xsl:param name="documentation-title" tunnel="yes" />
    <xsl:param name="is-root" as="xs:boolean" tunnel="yes" select="false()" />

    <nav id="side-navigation" class="bs-docs-sidebar hidden-print hidden-xs">
          <xsl:variable name="listItems" as="node()*">
            <xsl:apply-templates mode="generate-html5-nav"
              select=".
              except (
              *[df:class(., 'topic/title')],
              *[df:class(., 'map/topicmeta')],
              *[df:class(., 'map/reltable')]
              )"
            />
          </xsl:variable>

        <xsl:if test="$listItems">
          <ul class="nav bs-docs-sidenav">
            <xsl:sequence select="$listItems"/>
          </ul>
        </xsl:if>
    </nav>

  </xsl:template>

  <xsl:template name="nav-child-items">
    <xsl:param name="listItems" as="node()*" />
    <ul class="nav">
      <xsl:sequence select="$listItems"/>
    </ul>
  </xsl:template>

  <xsl:template name="header-navigation">
    <xsl:param name="navigation" as="element()" tunnel="yes"/>
    <xsl:apply-templates select="$navigation" mode="header-mini-toc"/>
  </xsl:template>

  <xsl:template match="li" mode="header-mini-toc">
    <xsl:param name="topicref" as="element()?" tunnel="yes"/>
    <xsl:choose>
    <xsl:when test="@id = generate-id($topicref)">

      <xsl:if test="ancestor::li[1]">
        <ul class="nav navbar-nav nav-part nav-parent hidden-sm hidden-md hidden-lg">
          <xsl:apply-templates select="ancestor::li[1]" mode="header-mini-toc-first-child"/>
        </ul>
      </xsl:if>

       <xsl:if test="not(ancestor::li[1])">
        <ul class="nav navbar-nav hidden-sm hidden-md hidden-lg">
          <xsl:apply-templates select="descendant::li" mode="header-mini-toc-first-child"/>
        </ul>
      </xsl:if>

      <xsl:if test="preceding-sibling::li">
        <ul class="nav navbar-nav nav-part nav-preceeding hidden-sm hidden-md hidden-lg">
          <xsl:apply-templates select="preceding-sibling::li" mode="header-mini-toc-first-child"/> 
        </ul>
      </xsl:if>

      <xsl:if test="following-sibling::li">
        <ul class="nav navbar-nav nav-part nav-following hidden-sm hidden-md hidden-lg">
          <xsl:apply-templates select="following-sibling::li" mode="header-mini-toc-first-child"/>
        </ul>
      </xsl:if>

      <xsl:if test="ancestor::li[1]/following-sibling::li[1]">
        <ul class="nav navbar-nav nav-part nav-next-section hidden-sm hidden-md hidden-lg">
          <xsl:apply-templates select="ancestor::li[1]/following-sibling::li[1]" mode="header-mini-toc-first-child"/>
        </ul>
      </xsl:if>
   </xsl:when>
   <xsl:otherwise>
     <xsl:apply-templates mode="#current"/>
   </xsl:otherwise>
   </xsl:choose>  
  </xsl:template>

  <xsl:template match="li" mode="header-mini-toc-first-child">
    <li>
      <xsl:apply-templates mode="#current"/>
    </li>
  </xsl:template>

  <xsl:template match="ul" mode="header-mini-toc-first-child" />

  <xsl:template match="a" mode="header-mini-toc-first-child">
    <xsl:sequence select="."/>
  </xsl:template>

  <xsl:template match="*" mode="header-mini-toc-first-child"/>

  <xsl:template match="*" mode="header-mini-toc">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="text()" mode="header-mini-toc"/>



</xsl:stylesheet>
