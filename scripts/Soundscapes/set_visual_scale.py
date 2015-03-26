#! .env/bin/python

import sys
import a2pyutils.palette
from soundscape.set_visual_scale_lib import run

USAGE = """
{prog} soundscape_id max_visual_scale [palette_id]
    soundscape_id - id of the soundscape whose image to edit
    max_visual_scale - clip range maximum (if '-', then it is
                       computed automatically)
    palette_id - index of the gradient palette to use
                (defined in a2pyutils.palette)
""".format(
    prog=sys.argv[0]
)
    
if len(sys.argv) < 3:
    print USAGE
    sys.exit()
else:
    soundscapeId = int(sys.argv[1])
    clipMax = None if sys.argv[2] == '-' else int(sys.argv[2])
    paletteId = (
        (int(sys.argv[3]) if len(sys.argv) > 3 else 0) %
        len(a2pyutils.palette.palette))
    run(soundscapeId,clipMax,paletteId)
    print 'end'
