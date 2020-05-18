# GRIP-Heatmap
R-function to display body heat maps using data from Graphical index of pain (GRIP).
Steingrímsdóttir ÓA; Engdahl B, Hansson P, Stubhaug A, Nielsen CS. The Graphical Index of Pain (GRIP): a new web-based method for high throughput screening of pain. Pain 2020 Apr 24. doi: 10.1097/j.pain.0000000000001899.

The function convert a data matrix into a set of given colors using a given color palettes used to color the bodyparts of a manikin. The colored manikin is saved in svg-format and different other plot-formats.

Input data has a structure with body parts in one of two different levels:
- First tier: 10 body parts
- Second tier: 173 body parts

Examples of file structure of data input is found under data:
- first_tier.csv
- second_tier.csv

The filestructure are colon delimited csv-file. The first row is the standardised names of the bodyparts. The second row is the numbers to be presented as colors. This could be either prevalences, pain-rating (VAS), differences, odds ratios etc. 

The original manikin svg-graphics that must be downloaded are found under GRIP-svg.
The svg-files of the manikins are originally from Kari Toverud in ai-format. Using Inkscape, areas are joined into bodyparts and named and files stored as svg. The line near the top where it says "inkscape:version=[something]" has been manually removed in a texteditor. 

An example of R-code running the GRIP-Heatmap function is found under examples: 

See also the source code for the GRIP: https://github.com/unioslo/kroppskart
