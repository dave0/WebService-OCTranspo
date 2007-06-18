<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!--

	This stylesheet generates an Inkscape-flavoured SVG image, of size
	3"x5", suitable for printing onto index cards.

	To script this process:

	1) fetch your schedule from http://servername/schedule/stop/NNNN/route/MMM?type=weekday
	   and save into file (MMM.xml, for example)
	2) run "xsltproc octranspo.xslt MMM.xml > MMM.svg to generate the SVG file.
	   This SVG can be opened in Inkscape and manipulated, or:
	3) run "inkscape -e MMM.png MMM.svg" to generate a PNG file from the
	   SVG on the commandline.

	   Alternatively, convert to EPS for inclusion by App::Hipster:
	      inkscape -E MMM.eps -B -T MMM.svg
	   (-B preserves the bounding box, and -T ensures that our text is
	   exported as paths, so that font substitution isn't necessary)

	Created with Inkscape (http://www.inkscape.org/)
-->
<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<xsl:template match="/schedule">
<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://web.resource.org/cc/"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   width="270"
   height="450"
   id="svg2"
   sodipodi:version="0.32"
   inkscape:version="0.44.1"
   version="1.0"
   sodipodi:docbase="/home/dmo/code/App-Hipster"
   sodipodi:docname="octranspo.svg">
  <defs
     id="defs4" />
  <sodipodi:namedview
     id="base"
     pagecolor="#ffffff"
     bordercolor="#666666"
     borderopacity="1.0"
     gridtolerance="10000"
     guidetolerance="10"
     objecttolerance="10"
     inkscape:pageopacity="0.0"
     inkscape:pageshadow="2"
     inkscape:zoom="1.4"
     inkscape:cx="259.7329"
     inkscape:cy="197.11964"
     inkscape:document-units="px"
     inkscape:current-layer="layer3"
     width="3in"
     height="5in"
     units="in"
     inkscape:window-width="1278"
     inkscape:window-height="989"
     inkscape:window-x="0"
     inkscape:window-y="0" />
  <metadata
     id="metadata7">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <g
     inkscape:label="Base"
     inkscape:groupmode="layer"
     id="layer1"
     style="opacity:1;display:inline"
     sodipodi:insensitive="true" />
  <g
     inkscape:groupmode="layer"
     id="layer2"
     inkscape:label="Headings"
     style="display:inline">
    <text
       xml:space="preserve"
       style="font-size:12px;font-style:normal;font-variant:normal;font-weight:bold;font-stretch:normal;text-align:start;line-height:125%;writing-mode:lr-tb;text-anchor:start;fill:black;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;font-family:Bitstream Vera Sans"
       x="6.7707887"
       y="19.285713"
       id="routeName"
       sodipodi:linespacing="125%"><tspan
         sodipodi:role="line"
         id="tspan3003"
         x="6.7707887"
         y="19.285713"><xsl:value-of select="route_number"/> <xsl:value-of select="route_name"/></tspan></text>
    <text
       xml:space="preserve"
       style="font-size:8px;font-style:normal;font-variant:normal;font-weight:bold;font-stretch:normal;text-align:start;line-height:100%;writing-mode:lr-tb;text-anchor:start;fill:black;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;font-family:Bitstream Vera Sans"
       x="8.5714283"
       y="396.42856"
       id="notesTitle"
       sodipodi:linespacing="100%"><tspan
         sodipodi:role="line"
         id="tspan2799"
         x="8.5714283"
         y="396.42856">Notes</tspan></text>
    <text
       xml:space="preserve"
       style="font-size:10px;font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;text-align:start;line-height:125%;writing-mode:lr-tb;text-anchor:start;fill:black;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;font-family:Bitstream Vera Sans"
       x="7.142859"
       y="32.142857"
       id="stopName"
       sodipodi:linespacing="125%"><tspan
         sodipodi:role="line"
         id="tspan2997"
         x="7.142859"
         y="32.142857"><xsl:value-of select="stop_name"/> (<xsl:value-of select="stop_number"/>)</tspan></text>
    <text
       xml:space="preserve"
       style="font-size:12px;font-style:normal;font-variant:normal;font-weight:bold;font-stretch:normal;text-align:start;line-height:125%;writing-mode:tb-rl;text-anchor:start;fill:black;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;font-family:Bitstream Vera Sans"
       x="257.85715"
       y="4.2857146"
       id="text2999"
       sodipodi:linespacing="125%"><tspan
         sodipodi:role="line"
         id="tspan3001"
         x="4.2857146"
         y="257.85715"><xsl:value-of select="type"/></tspan></text>
  </g>
  <g
     inkscape:groupmode="layer"
     id="layer3"
     inkscape:label="Schedule"
     style="display:inline">
    <rect
       style="fill:none;fill-opacity:1;stroke:none;stroke-width:1.00853515;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;display:inline"
       id="rect2801"
       width="44.991467"
       height="338.27719"
       x="7.1471248"
       y="39.432842" />
    <rect
       style="fill:none;fill-opacity:1;stroke:none;stroke-width:1.00853515;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;display:inline"
       id="rect2811"
       width="44.991467"
       height="338.27719"
       x="162.23642"
       y="39.432842" />
    <rect
       style="fill:none;fill-opacity:1;stroke:none;stroke-width:1.00853515;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;display:inline"
       id="rect2813"
       width="44.991467"
       height="338.27719"
       x="110.53998"
       y="39.432842" />
    <rect
       style="fill:none;fill-opacity:1;stroke:none;stroke-width:1.00853515;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;display:inline"
       id="rect2815"
       width="44.991467"
       height="338.27719"
       x="58.843555"
       y="39.432842" />
    <rect
       style="fill:none;fill-opacity:1;stroke:none;stroke-width:1.00853515;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;display:inline"
       id="rect2817"
       width="44.991467"
       height="338.27719"
       x="213.93285"
       y="39.432842" />
    <flowRoot
       xml:space="preserve"
       style="font-size:8px;font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;text-align:start;line-height:125%;writing-mode:lr-tb;text-anchor:start;fill:black;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;display:inline;font-family:Bitstream Vera Sans Mono"
       id="scheduleTimes"
       transform="matrix(1,0,0,0.955608,0,16.76719)"><flowRegion
         id="flowRegion2845"><use
           x="0"
           y="0"
           xlink:href="#rect2801"
           id="use2847"
           transform="matrix(1,0,0,1.046454,0,-17.54609)"
           width="270"
           height="450" /><use
           x="0"
           y="0"
           xlink:href="#rect2815"
           id="use2849"
           transform="matrix(1,0,0,1.046454,0,-17.54609)"
           width="270"
           height="450" /><use
           x="0"
           y="0"
           xlink:href="#rect2813"
           id="use2851"
           transform="matrix(1,0,0,1.046454,0,-17.54609)"
           width="270"
           height="450" /><use
           x="0"
           y="0"
           xlink:href="#rect2817"
           id="use2853"
           transform="matrix(1,0,0,1.046454,0,-17.54609)"
           width="270"
           height="450" /></flowRegion><xsl:for-each 
		select="times/time"><flowPara><xsl:value-of select="." /></flowPara></xsl:for-each> </flowRoot><rect
       style="fill:none;fill-opacity:1;stroke:none;stroke-width:1.007074;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;display:inline"
       id="rect2865"
       width="251.42151"
       height="39.278641"
       x="9.2892513"
       y="401.4321" />
    <flowRoot
       xml:space="preserve"
       style="font-size:8px;font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;text-align:start;line-height:125%;writing-mode:lr-tb;text-anchor:start;fill:black;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;display:inline;font-family:Bitstream Vera Sans Mono"
       id="notes"><flowRegion
         id="flowRegion2873"><use
           x="0"
           y="0"
           xlink:href="#rect2865"
           id="use2875"
           width="270"
           height="450" /></flowRegion><xsl:for-each 
		select="notes/note"><flowPara><xsl:value-of select="id" /> - <xsl:value-of select="content" /></flowPara></xsl:for-each> </flowRoot></g>
</svg>
</xsl:template>
</xsl:stylesheet>
