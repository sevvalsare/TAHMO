// Points
//var point = ee.Geometry.Point([69.15, 54.8331]);
var lng = -0.24447074; 
var lat = 5.5730222;
var point = ee.Geometry.Point([lng, lat]);
// Collection of point
var pts = ee.FeatureCollection(ee.List([ee.Feature(point)]));

// Start and End Dates
var inidate = ee.Date.fromYMD(2018,1,01)
var enddate = ee.Date.fromYMD(2022,1,01)

// Difference between start and end in days 
var difdate = enddate.difference(inidate, 'day')

// Import GSMaP data
var gsmap = ee.ImageCollection('JAXA/GPM_L3/GSMaP/v6/operational')
.filterDate(inidate, enddate)
.select('hourlyPrecipRate');

// Time lapse
var lapse = ee.List.sequence(0, difdate.subtract(1))
var inidate = ee.Date('2018-1-01')
var listdates = lapse.map(function(day){
  return inidate.advance(day, 'day')
})

// Iterate over the list of dates
var newft = ee.FeatureCollection(listdates.iterate(function(day, ft) {
  // Cast
  ft = ee.FeatureCollection(ft)
  day = ee.Date(day)

  // Filter the collection in one day (24 images)
  var day_collection = gsmap.filterDate(day, day.advance(1, 'day'))

  // Get the sum of all 24 images into one Image
  var sum = ee.Image(day_collection.sum())

  // map over the ft to set a property over each feature
  var temp_ft = ft.map(function(feat){
    var geom = feat.geometry()
    var value = sum.reduceRegion(ee.Reducer.first(), geom, 1000).get('hourlyPrecipRate')
    return feat.set(day.format('YYYY-MM-dd'), value)
  })

  // Return the FeatureCollection with the new properties set
  return temp_ft
}, pts))


// get the dates and the rain intensity per day
var dates = newft.first().toDictionary().keys();
var rain = newft.first().toDictionary().values();

// build a feature collection with property rain and date
var correctFeats = ee.FeatureCollection(dates.map(function(date){
  var ind = dates.indexOf(date);
  var rainAtDate = rain.get(ind);
  var feat = ee.Feature(point, {date: ee.Date(date), rain: rainAtDate})
  return feat;
}));
print(correctFeats);

//Making a chart
var chart = ui.Chart.feature.byFeature(correctFeats, 'date', 'rain')
print(chart);
