# Harris-Corner-Detector
**CS-867  Computer Vision Assignment # 1 Spring 2021**

**Harris Keypoint Detector and its Robustness to Rotation and Scaling**

Harris Corner Detector is a corner detection operator that is commonly used in computer vision algorithms to extract corners and infer features of an image.Harris’ corner detector takes the differential of the corner score into account with reference to direction directly, instead of using shifting patches for every 45-degree angles, and has been proved to be more accurate in distinguishing between edges and corners. 
![image](https://user-images.githubusercontent.com/79583184/198843910-d4e0657f-7cf6-4bfb-8102-5eb8757bcad1.png)

**Corner**
A corner is a point whose local neighborhood stands in two dominant and different edge directions. In other words, a corner can be interpreted as the junction of two edges, where an edge is a sudden change in image brightness. Corners are the important features in the image, and they are generally termed as interest points which are invariant to translation, rotation, and illumination.
![image](https://user-images.githubusercontent.com/79583184/198843966-5f89bb2f-b144-41c2-91f0-c81fcb31280e.png)  


So let's understand why corners are considered better features or good for patch mapping. If we take the flat region then no gradient change is observed in any direction. Similarly, in the edge region, no gradient change is observed along the edge direction. So both flat region and edge region are bad for patch matching since they not very distinctive (there are many similar patches in along edge in edge region). While in corner region we observe a significant gradient change in all direction. Due this corners are considered good for patch matching(shifting the window in any direction yield a large change in appearance) and generally more stable over the change of viewpoint.

**Corner Detection**
The idea is to consider a small window around each pixel p in an image. We want to identify all such pixel windows that are unique. Uniqueness can be measured by shifting each window by a small amount in a given direction and measuring the amount of change that occurs in the pixel values.
![image](https://user-images.githubusercontent.com/79583184/198844050-bc44a0e3-07bb-47a6-a163-a3c785eb849e.png)
More formally, we take the sum squared difference (SSD) of the pixel values before and after the shift and identifying pixel windows where the SSD is large for shifts in all 8 directions. Let us define the change function E(u,v) as the sum of all the sum squared differences (SSD), where u,v are the x,y coordinates of every pixel in our 3 x 3 window and I is the intensity value of the pixel. The features in the image are all pixels that have large values of E(u,v), as defined by some threshold.
![image](https://user-images.githubusercontent.com/79583184/198844093-7f3d2a20-5b91-4728-a7d8-7919bcb9a23a.png)

We have to maximize this function E(u,v) for corner detection. That means, we have to maximize the second term. Applying Taylor Expansion to the above equation and using some mathematical steps, we get the final equation as:
![image](https://user-images.githubusercontent.com/79583184/198844110-7ee04089-633a-476d-a410-846e1f2a42ad.png)

Now, we rename the summed-matrix, and put it to be M:
![image](https://user-images.githubusercontent.com/79583184/198844125-c51052fd-887a-495f-a4a0-118fd82a74ad.png)

So the equation now becomes:
![image](https://user-images.githubusercontent.com/79583184/198844145-c2607bc3-9bdf-4f94-857d-88a5d19a128e.png)

**High-level pseudocode**
Take the grayscale of the original image
2. Apply a Gaussian filter to smooth out any noise

3. Apply Sobel operator to find the x and y gradient values for every pixel in the grayscale image

4. For each pixel p in the grayscale image, consider a 3×3 window around it and compute the corner strength function. Call this its Harris value.

5. Find all pixels that exceed a certain threshold and are the local maxima within a certain window (to prevent redundant dupes of features)

6. For each pixel that meets the criteria in 5, compute a feature descriptor.



