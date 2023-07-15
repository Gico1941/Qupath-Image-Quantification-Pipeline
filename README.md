# Qupath Image Quantification Pipeline
## Description
A pipeline for immunefluorescence image and H&E image quantification analysis with Qupath

## Overview

![Picture5](https://github.com/Gico1941/Qupath-Image-Quantification-Pipeline/assets/127346166/6062c87a-c51a-47f4-babc-7e861945f71a)

## Software dependencies :
Qupath https://qupath.github.io/

## Usage
### Immunefluorescence Image Analysis
1. Create Qupath project and import image files
   
2. Set up Channel name (as shown in Qupath Multiplexed analysis Tuttorial : https://qupath.readthedocs.io/en/0.4/docs/tutorials/multiplex_analysis.html, Run for project)
```
setChannelNames(
     'PDL1',
     'CD8',
     'FoxP3',
     'CD68',
     'PD1',
     'CK'
)
```
3.Draw objects containing region of interest (e.g. region highlighted with yellow line, example image source : https://qupath.readthedocs.io/en/0.4/docs/intro/acknowledgements.html  /  LuCa-7color_[13860,52919]_1x1):

<img src="https://github.com/Gico1941/Qupath-Image-Quantification-Pipeline/assets/127346166/2311c8e3-bce7-48c2-8468-5601a4c0e755" width="400" />

4.Run Cell detection for each object (change the parameters to fit specific samples, Run for project):
```
selectAnnotations();  
runPlugin('qupath.imagej.detect.cells.WatershedCellDetection','{"detectionImage":"DAPI","requestedPixelSizeMicrons":0.5,"backgroundRadiusMicrons":8.0,"backgroundByReconstruction":true,"medianRadiusMicrons":0.0,"sigmaMicrons":1.5,"minAreaMicrons":10.0,"maxAreaMicrons":400.0,"threshold":1.0,"watershedPostProcess":true,"cellExpansionMicrons":2.5,"includeNuclei":true,"smoothBoundaries":true,"makeMeasurements":true}')
resetSelection();
```
<img src="https://github.com/Gico1941/Qupath-Image-Quantification-Pipeline/assets/127346166/71105e86-689a-4b72-92d3-bd933971af55" width="400" />

3. Specify positive/negative itensity threshold for each channel/Cell marker (e.g. As shown in two pictures, compared witht 0.5 or lower, 3.0 might be a more applicable threshold for 'CD8' channel) 

<img src="https://github.com/Gico1941/Qupath-Image-Quantification-Pipeline/assets/127346166/afdf4ceb-94f4-4fca-a9a6-51cf0eea43f3" width="500" />

<img src="https://github.com/Gico1941/Qupath-Image-Quantification-Pipeline/assets/127346166/3ab1c698-05f0-44d6-9610-443a4838fe10" width="500" />


Specified threshold of all channels in script (e.g.  ['channel name', 'Measurement','threshold (above cells will be considered as positive)']  ):
```
def classifiers = [
['PD1', 'Cell: PD1 mean', 8.0],
['CD8', 'Cytoplasm: CD8 mean',4.0],
......
]
```

4. Now classify cells with main function (Run for project) :
```
// main function
// initialize name
for (cell in getCellObjects()){
	if(cell.getPathClass() != 'null')
		cell.setPathClass(getPathClass('null'))
}

// now classify cells
for ( cl in classifiers){
	for (cell in getCellObjects()) {
    		ch = measurement(cell, cl[1])
		class_ = cell.getPathClass().toString()
		if ( class_ == 'null'){
			positive = getPathClass(cl[0] + '+')
			negative = getPathClass(cl[0] + '-')
		}
		else{
			positive = getPathClass(class_ + ',' + cl[0] + '+')
			negative = getPathClass(class_ + ',' + cl[0] + '-')
		}
		if (ch > cl[2]){
			cell.setPathClass(positive)
   		}
		else{
			cell.setPathClass(negative)
}}}
```
<img src="https://github.com/Gico1941/Qupath-Image-Quantification-Pipeline/assets/127346166/240067bd-08e3-4ac1-a7ae-5ae6c1dab211" width="400" />


5.Export data into .txt files (Run for project)
```
def name = getProjectEntry().getImageName() + '.txt'	 
 	def path = buildFilePath(PROJECT_BASE_DIR, 'Results')
 	mkdirs(path)
 	path = buildFilePath(path, name)
 	saveAnnotationMeasurements(path)
 	print 'Results exported to ' + path
```

6.Run the Qupath_merge_results.groovy to generate .csv file that integrates all statistics of the project

7.Downstream visualization 
