# picframe
Create picture frame for your desktop using conky and imagemagick.

All the imagemagick tricks are from

    http://www.imagemagick.org/Usage/thumbnails/index.html and
    http://www.imagemagick.org/Usage/advanced/

Installation:

    mkdir -p ~/bin/
    chmod +x picframe.sh
    mv picframe.sh ~/bin/

Usage:

    picframe.sh [other-options] -u your-imagefile.jpg > picframe.lua
   
Various frame types are available. 
Example: none, wooden, polaroid, polaroid-tack, torn-paper, torn-paper-edge.
Default frame type: polaroid

Check out screenshot folder to view the various frame types.
