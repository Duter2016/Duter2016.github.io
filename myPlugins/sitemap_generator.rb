# Sitemap.xml Generator is a Jekyll plugin that generates a sitemap.xml file by 
# traversing all of the available posts and pages.
# 
# See readme file for documenation
# 
# Updated to use config file for settings by Daniel Groves
# Site: http://danielgroves.net
# 
# Author: Michael Levin
# Site: http://www.kinnetica.com
# Distributed Under A Creative Commons License
#   - http://creativecommons.org/licenses/by/3.0/
require 'jekyll/document'
require 'rexml/document'

module Jekyll

  class Jekyll::Document
    attr_accessor :name

 
