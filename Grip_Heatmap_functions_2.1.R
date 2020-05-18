
##############################################################################################################
# GRIP_Heatmap_functions ver. 2.1 
# 27.03.2020 - Bo Engdahl, National institute of public health, Norway
# 
# Spesific plotFunctions: 
#
# plotHeat()
# Description
# The functions convert a data matrix into a set of given colors using a given color palettes used to color the 
# bodyparts of a manikin. The colored manikin is saved in svg-format and a plot-format.
# 
# Usage:
# plotHeat(svg_name, grip_name, image_name, color_start_stop=c("yellow", "red", "black"), n_colors=100, d_range=c(0,1), 
# output_format="png", leg=FALSE, horizontal=TRUE)
#
# Arguments:
# svg_name          name of original svg-file of manikin or bodypart (first_tier_man.svg, first_tier_woman.svg, second_tier_man.svg, second_tier_woman.svg, 
#                   mouth, feet.svg, hands.svg, teeth.svg, head.svg)
# grip_name         name of datafile, with grip-data in a structure with bodynames: grip_bodyname (csv with ";" delimiter)
# image_name        name of output image file
# output_format     output_format for converting svg (png, pdf, ps)
# color_start_stop  Start and stop colors in hex
# n_colors          Number of colors
# d_range           Range of values
# leg               plot legend (TRUE, FALSE)
# horizontal        legend is vertical (FALSE) or horizontal (TRUE)
#
# Comments: The svg-files of the manikins are originally from Kari Toverud in ai-format. Using Inkscape, areas are joined into bodyparts and
# named and files stored as svg. The line near the top where it says "inkscape:version=[something]" has been manually removed in a texteditor. 
# 
# Also see the source code for the Grid: https://github.com/unioslo/kroppskart
#
#
# Other general plotFunctions:
#
# convertImage<-function(name, output_format)
# Convert the svg-file to another format - png, pdf or ps
#
# drawLegend<-function(color_start_stop=c("yellow", "red"), n_colors=100, range=c(0,1), 
#                     output_format="png", horizontal=FALSE)
# Plot a legend
#
# Check for packages and install missing ones
list.of.packages <- c("XML", "rsvg", "png")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
library(XML)
library(rsvg)
library(png)




##########################################################################
# convert the svg image to pdf, png or ps  
# using the package rsvg 
# 
##########################################################################
convertImage<-function(name, output_format){
  # draw on a magick device
  image_name<-paste(image_dir, name, sep='')
  svg_in <-paste(image_name, ".svg", sep='') 
  if ( output_format == "pdf") {
    rsvg_pdf(svg_in, paste(image_name,".",output_format, sep=''))
  } else if ( output_format == "ps") {
    rsvg_ps(svg_in, paste(image_name,".",output_format, sep=''))
  } else if ( output_format == "png") {
    bitmap<-rsvg(svg_in, height=1000)
    png::writePNG(bitmap, paste(image_name,".",output_format, sep=''), dpi = 200)
    # Changed fomr height 4000 and dpi 400
  } else { 
    print("Output format illegal")
  }
} 

##########################################################################
# draww a legend
##########################################################################
drawLegend<-function(color_start_stop=c("yellow", "red", "black"), n_colors=100, range=c(0,1), 
                     name, output_format="png", horizontal=TRUE){
  path_name<-paste(image_dir, name, "_legend.", output_format, sep='')
  colorLevels <- seq(min(range), max(range), length=n_colors)
  colorRamp <- colorRampPalette(color_start_stop)(length(colorLevels) - 1)
  if (horizontal) {
    ncol=1
    nrow=length(colorLevels)
    x=colorLevels
    y=1
    yaxt="n"
    xaxt="s"
    las=0
    width=480
    height=120
    mar = c(2,2,2,2)
    side=1
  } else
  {
    ncol=length(colorLevels)
    nrow=1
    x=1
    y=colorLevels
    xaxt="n"
    yaxt="s"
    las=1
    side=4
    width=140
    height=480
    mar = c(2,2,2,4)
    side=4
  } 
  if (output_format=="png") {
    png(filename=path_name, width=width, height=height)
  }  
  else if ( output_format == "pdf") {
    pdf(file=path_name, width=width/79, height=height/79)
  }
  else if ( output_format == "ps") {
    postscript(file=path_name, width=width/79, height=height/79)
  }  
  else { 
  print("Output format illegal")
  }
  par(mar = mar)
  img<-image(x, y,
             matrix(data=colorLevels, ncol=ncol, nrow=nrow),
             col=colorRamp,
             xlab="", ylab="",
             axes=FALSE,
             xaxt=xaxt, yaxt=yaxt, bty="n") 
  axis(side=side, cex.axis=2,las=las) 
  dev.off()
}


  #######################################################################
  # Funcion to plot heat map image - use package  XML
  #######################################################################
  
  plotHeat<-function(svg_name, grip_name, image_name, color_start_stop=c("yellow", "red", "black"), n_colors=100, range=c(0,1), 
                    output_format="png", leg=FALSE, horizontal=TRUE){
    svg_file_name<-paste(svg_dir, svg_name, sep='')
    grip_dir_name<-paste(grip_dir, grip_name, sep='')
    print(paste("Reading data from:", grip_dir_name))
    grip_mat <- read.csv2(grip_dir_name, header=TRUE)
    ## set color representation
    grip_range <- seq(min(range), max(range), length=n_colors)
    ## color_palett from start to stop
    color_palette <- colorRampPalette(color_start_stop)(length(grip_range) - 1)
    ## Add light grey to the last palette
    color_palette <- c(color_palette, "#D3D3D3")
    ## give each intensity a predefined color (modify probs argument of quantile to detail the colors)
    color_mat <- matrix(findInterval(grip_mat, grip_range, all.inside = TRUE), nrow = nrow(grip_mat))
    ## Set missing to the last palett 
    color_mat[is.na(color_mat)] <- n_colors
    
    ## Make a dataframe of bodyparts and colors 
    frame<-data.frame(colnames(grip_mat), color_palette[color_mat])

    ## Read in the svg-file
    svg <- xmlTreeParse(svg_file_name)
    ## Changing only color fill style
    styleprefix =
      "fill-opacity:1;fill-rule:nonzero;stroke:none;fill:"
       npaths=length(svg$doc$children$svg$children$g$children)
       
     ## Changing color of svg
    for(i in 1:nrow(frame)){
      for(j in 1:npaths){
        id = svg$doc$children$svg$children$g$children[j]$path$attributes["id"]
        ## if bodypart is a part of id
        if(grepl(frame[i,1], id)){
        svg$doc$children$svg$children$g$children[j]$path$attributes["style"] =
          paste0(styleprefix,frame[i,2])
        }
      }
    }
  ## Save results as svg
  saveXML(svg$doc$children$svg,
            paste(image_dir, image_name, ".svg", sep=''))
  # Save image as other plot
    if (output_format != "") {convertImage(image_name, output_format)}   
    print(paste("Save imagedata to:", paste(image_dir,image_name,".svg", sep='')))
  # Draw legend
    if (leg) {
      print("Drawing legend")
      drawLegend(color_start_stop,n_colors,range,image_name,output_format,horizontal)
    }
  }

