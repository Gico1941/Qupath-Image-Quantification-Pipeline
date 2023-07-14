// 1.rename IF channel (e.g.) -> run for project

setChannelNames('DAPI',
                'CD3',
                'CD8',
                'PD1',
                'TCF1')



// 2.Manually defien annotations (e.g.tumors)


// 3.Run cell detection  -> run for project
	// channel used for cell detetion (e.g 'DAPI')
selectAnnotations();  
runPlugin('qupath.imagej.detect.cells.WatershedCellDetection','{"detectionImage":"DAPI","requestedPixelSizeMicrons":0.5,"backgroundRadiusMicrons":8.0,"backgroundByReconstruction":true,"medianRadiusMicrons":0.0,"sigmaMicrons":1.5,"minAreaMicrons":10.0,"maxAreaMicrons":400.0,"threshold":100.0,"watershedPostProcess":true,"cellExpansionMicrons":5.0,"includeNuclei":true,"smoothBoundaries":true,"makeMeasurements":true}')
resetSelection();

// 4.Run Object classifier -> run for project
	// define your threshold (e.g PD1 and CD8)



def classifiers = [
['PD1', 'Cytoplasm: PD1 mean', 800],
['CD8', 'Cytoplasm: CD8 mean', 1600]
]




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



// 5. export data -> run for project
def name = getProjectEntry().getImageName() + '.txt'	 
 	def path = buildFilePath(PROJECT_BASE_DIR, 'Results')
 	mkdirs(path)
 	path = buildFilePath(path, name)
 	saveAnnotationMeasurements(path)
 	print 'Results exported to ' + path