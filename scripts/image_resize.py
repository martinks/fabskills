#!/usr/bin/env python3
import os
import glob
import logging
logging.basicConfig(level=logging.INFO)


# use 
#    pip install pillow 
# to install this stuff
from PIL import Image, ImageOps


if not hasattr(Image, 'Resampling'):  # Pillow<9.0
	Image.Resampling = Image

max_dimension = 1024 # maximum height or width
quality = 'web_high' # see https://jdhao.github.io/2019/07/20/pil_jpeg_image_quality/

in_dir = "original"
out_dir = "resized"

if not os.path.exists(out_dir):
    os.makedirs(out_dir)

in_files = glob.glob(os.path.join(in_dir,"*.jpg"))
for in_file in in_files:
	filename = os.path.split(in_file)[-1]
	out_file = os.path.join(out_dir, filename)

	# Check if input image exists
	if not os.path.exists(in_file):
		logging.warning('Image {} does not exist'.format(in_file))

	img = Image.open(in_file)

	# Rotate image if needed
	img = ImageOps.exif_transpose(img)

	width, height = img.size
	ratio = min(max_dimension/float(width), max_dimension/float(height))
	
	# only reduce image size, no enlargement
	if ratio < 1:
		new_size = (int(width*ratio), int(height*ratio))
		img = img.resize(new_size, Image.Resampling.LANCZOS)	

	logging.info("Writing {}".format(out_file))
	img.save(out_file,quality=quality)
