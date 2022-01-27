# RecycPal

![](https://i.imgur.com/2UEDT6v.png)

## Summary

RecycPal is your pal for creating a more sustainable world! RecycPal uses machine learning and artificial intelligence to help you identify what can be or cannot be recycled. 

This project was developed during DeltaHacks 8. Please check out our DevPost here: https://devpost.com/software/recycpal

## Motivation

The effects of climate change are already being felt, especially in recent times with record breaking temperatures being recorded in alarming numbers each year [1]. According to the Environmental Protection Agency [2], Americans generated 292.4 million tons of material solid waste in 2018. Out of that amount, 69 million tons of waste were recycled and another 25 million tons were composted. This resulted in a 32.1 percent recycling and composting rate. These numbers must improve if we want a greener and sustainable future. 

Our team believes that building software that will educate the public on the small things they can do to help will ultimately create a massive change. We developed RecycPal in pursuit of these greener goals and a desire to help other eco-friendly people make the world a better place. 

## Meet the Team

- Denielle Abaquita (iOS Front-end)
- Jon Abrigo (iOS Front-end)
- Justin Esguerra (ML, Back-end)
- Ashley Hart (ML, Back-end)

## Tech Stack

RecycPal was designed and built with the following technolgies: 
- Figma
- CoreML
- XCode

We also utilize some free art assets from Flaticon. [3]


## Frontend

![](https://i.imgur.com/B3JL1yw.jpg)

### History Tab

| History Tab Main | Previous Picture |
| -------- | -------- |
|   ![](https://i.imgur.com/HX0f5lz.png) | ![](https://i.imgur.com/muQqlB6.png) |


The purpose of this tab is to let the user see the pictures they have taken in the past. At the top of this tab will be a cell that leads to finding the nearest recycling center for easy access to this important feature. 

Each cell in this section will lead to a previously taken picture by the user and will be labeled with the date the user took the picture. 

### Camera Tab

| Pointing the Camera | Picture Taken | 
| -------- | -------- | 
| ![](https://i.imgur.com/xV6ewzG.png) | ![](https://i.imgur.com/N7JbOYH.png) | 

The purpose of this tab is to take a picture of the user's surroundings to identify any recyclable objects in the frame. Each picture will be automatically saved into the user's history. We utilized Apple's CoreML and Vision APIs to complete this section. [4, 5]

After the user takes a picture, the application will perform some machine learning algorithms in the backend to identify any objects in the picture. The user will then see the object highlighted and labeled within the picture. 

Afterwards, the user has the option to take another picture. 

### Information Tab

| Information Tab | More Info on Paper | 
| -------- | -------- | 
| ![](https://i.imgur.com/nJBGvqt.png) | ![](https://i.imgur.com/OQCHm9F.png)| 

The purpose of this tab is to provide the user information on the nearest recycling centers and the best recycling practices based on the materials. We consulted resources provided by the Environmental Protection Agency to gather our information [6].

In this case, we have paper, plastic, and metal materials. We will also include glass and non-recyclables with information on how to deal with them. 

## Backend


### Machine Learning

This was our team's first time tackling machine learning and we were able to learn about neural networks, dataseet preparation, the model training process and so much more. We took advantage of CoreML [7] to create a machine learning model that would receive a photo of an object taken by the user and attempt to classify it into one of the following categories:

1. Cardboard
2. Paper
3. Plastic
4. Metal 
5. Glass 
6. Trash

The training process introduced some new challenges that our team had to overcome. We used datasets from Kaggle [8, 9] and the TACO project [10] to train our model. In order to test our data, we utilized a portion of our data sets that we did not train with and took pictures of trash we had in our homes to give the model fresh input to predict on.

We worked to ensure that that our results would have a confidnece rating of at least 80% so the front-end of the application could take that result and display proper infromation to the user. 


## What We Learned

### Denielle 

RecycPal is the result of the cumulative effort of 3 friends wanting to build something useful and impactful. During this entire project, I was able to solidifiy my knowledge of iOS development after focusing on web development for the past few months. I was also able to learn AVFoundation and CoreML. AVFoundation is a framework in iOS that allows developers to incorporate the camera in their applications. CoreML, on the other hand, helps with training and developing models to be used in machine learning. Overall, I learned so much, and I am happy to have spent the time to work on this project with my friends. 

### Justin
Starting on this project, I had a general idea of how machine learning models work, but nothing prepared for me the adventure that ensued these past 36 hours. I learned CoreML fundamentals, how to compile and annotate datasets, and expanded my knowledge in XCode. These are just the tip of the iceberg considering all of our prototypes we had to scrap, but it was a privelege to grind this out with my friends.

### Jon 
I have learned A TON of things to put it simply. This was my first time developing on the frontend so most of the languages and process flow were new to me. I learned how to navigate and leverage the tools offered by Figma and helped create the proof of concept for RecycPal's application. Learned how to develop with Xcode and Swift and assist on creating the launch screen and home page of the application. Overall, I am thankful for the opportunity that I have been given throughout this Hackathon.

### Ashley
This project served as my first hands on experience with machine learning. I learned about machine learning tasks such as image classification, expermineted with the many utilities that Python offers for data science and I learned how to organize, label, create, and utilize data sets. I also lerned how libaries such as numpy and matplotlib could be combined with frameworks such as PyTorch to build neural networks. I was also able to experiment with Kaggle and Jyupter Notebooks.

## Challenges We Ran Into

### Denielle 

The biggest challenges I have ran into are the latest updates to Xcode and iOS. Because it has been some time since I last developed for iOS, I have little familiarity with the updates to iOS 15.0 and above. In this case, I had to adjust to learn UIButton.Configuration and Appearance configurations for various components. As a result, that slowed down development a little bit, but I am happy to have learned about this updates! In the end, the updates are a welcome change, and I look forward to learning more and seeing what's in store in the future. 

### Justin
I didn't run into challenges. The challenges ran over me. From failing to implent PyTorch into our application, struggling to create Numpy (Python) based datasets, and realizing that using Google Cloud Platform for remote access to the database was too tedious and too out of the scope for our project. Despite all these challenges we persevered until we found a solution, CoreML. Even then we still ran into Xcode and iOS updates and code depracations which made this inifinitely more frustrating but ten times more rewarding. 

### Jon 
This was my first time developing on the front end as I have mainly developed on the backend prior. Learning how to create prototypes like the color schema of the application, creating and resizing the application's logos and button icons, and developing on both the programmatic and Swift's storyboards methods were some of the challenges I faced throughout the event. Although this really slowed the development time, I am grateful for the experience and knowledge I have gained throughout this Hackathon.

### Ashley
I initially attempted to build a model for this application using PyTorch. I chose this framework because of its computing power, accessible documentation. Unfortunately, I ran into several errors when I had to convert my images into inputs for a neural network. On the bright side, we found Core ML and utilized it in our application with great success. My work with PyTorch is not over as I will continue to learn more about it for my personal studies and for future hackathons. I also conducted research for this project and learned more about how I can recycle waste.

## What's Next for RecycPal?
Future development goals include:
- Integrating computer vision, allowing the model to see and classify multiple objects in real time.
- Bolstering the accuracy of our model by providing it with more training data.
- Getting user feedback to improve user experience and accessibility.
- Conducting research to evaluate how effective the application is at helping people recycle their waste. 
- Expanding the classifications of our model to include categories for electronics, compostables, and materials that need to be taken to a store/facility to be proccessed.
- Adding waste disposal location capabilites, so the user can be aware of nearby locarions where they can process their waste. 

### Conclusion
Thank you for checking out our project! If you have suggestions, feel free to reach out to any of the RecycPal developers through the socials we have attached to our DevPost accounts. 


## References 
[1] Climate change evidence: How do we know? 2022. NASA. https://climate.nasa.gov/evidence/. 

[2] EPA. 2018.  National Overview: Facts and Figures on Materials, Wastes and Recycling. https://www.epa.gov/facts-and-figures-about-materials-waste-and-recycling/national-overview-facts-and-figures-materials. 

[3] EPA. How Do I Recycle?: Common Recyclables.  https://www.epa.gov/recycle/how-do-i-recycle-common-recyclables. 

[4] Apple. Classifying Images with Vision and Core ML. Apple Developer Documentation. https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml. 

[5] Chang, C. 2018. Garbage Classification. Kaggle. https://www.kaggle.com/asdasdasasdas/garbage-classification. 

[6] Sekar, S. 2019. Waste classification data. Kaggle. https://www.kaggle.com/techsash/waste-classification-data.

[7] Pedro F Proença and Pedro Simões. 2020. TACO: Trash Annotations in Context for Litter Detection. arXiv preprint arXiv:2003.06975 (2020).
