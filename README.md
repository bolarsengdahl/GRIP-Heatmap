# GRIP-Heatmap
R-function to display body heat maps using data from Graphical index of pain (GRIP) 
The function convert a data matrix into a set of given colors using a given color palettes used to color the bodyparts of a manikin. The colored manikin is saved in svg-format and different other plot-formats.
Input data is has a structure with body parts in one of two different levels:
- First tier: 10 body parts
- Second tier: 173 body parts

Examples of file structure of data input is found under GRIP_data:
- first_tier.xlsx
- second_tier.xlsx

The original manikin svg-graphics that must be downloaded are found under GRIP_images.
The svg-files of the manikins are originally from Kari Toverud in ai-format. Using Inkscape, areas are joined into bodyparts and named and files stored as svg. The line near the top where it says "inkscape:version=[something]" has been manually removed in a texteditor. 
See also the source code for the GRIP: https://github.com/unioslo/kroppskart
