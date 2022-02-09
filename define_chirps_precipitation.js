var lng = 123.26;  //longitude
var lat = 44.5;    //latitude
var point = ee.Geometry.Point([lng, lat])



Map.setCenter(lng,lat, 5); // Center the map on this location, zoom level 10

var start = '2020-05-01'; // initial date of the image collection
var end = '2021-05-31'; //final date of the image collection

var dataset = ee.ImageCollection('UCSB-CHG/CHIRPS/DAILY')
    .filterDate(start, end)
var precipitation = dataset.select('precipitation');

    
print(ui.Chart.image.series(precipitation, point, ee.Reducer.first(), 1));

Export.table.toDrive({
    collection: precipitation, 
    description: 'precipitation', 
    folder: 'GEE', 
    fileNamePrefix: 'precipitation', 
    fileFormat: 'CSV'
})
