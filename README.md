# SVD-Compression
A matlab program that preforms image compression via SVD

One of the interesting results is how for color images, the convergence of the error towards the original image differs for each of the color channels. This, I suppose, would indicate how 'much' of the R,G,B channel is in the original image. Using the built-in 'autumn.tif', the red and green channels converge to the original image slower than the blue channel, so the image contains mostly red and green. 
