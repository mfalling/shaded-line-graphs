# Script from: http://www.nagraj.net/notes/gifs-in-r/

install.packages("magick")
library(magick)

## list file names and read in
imgs <- list.files(path = "output", 
                   pattern = ".png", 
                   full.names = TRUE)

img_list <- lapply(imgs, image_read)

## join the images together
img_joined <- image_join(img_list)

## animate at 2 frames per second
img_animated <- image_animate(img_joined, fps = 1)

## save to disk
image_write(image = img_animated,
            path = "output/linegraph.gif")
