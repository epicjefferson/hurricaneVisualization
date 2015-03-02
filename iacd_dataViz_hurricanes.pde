import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;  
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.marker.*;


UnfoldingMap map;
SimplePointMarker hurricaneMarker;
SimplePointMarker prevMarker;
SimplePointMarker currentMarker;


Table table;
color[] dotcolor = {};
int counter = 0;
String id,previd;
float lat,lon,prevlat,prevlon;

void setup(){
  size(800,600);
  map = new UnfoldingMap(this, new OpenStreetMap.OSMGrayProvider());
  MapUtils.createDefaultEventDispatcher(this, map);
  map.zoomToLevel(3);
  map.setZoomRange(3,8); // prevent zooming too far out
  map.panTo(21.0,31.0);
  
  smooth();
  
  //count how many different hurricanes there are.
  //each will have its own color
  table = loadTable("Basin.NA.ibtracs_wmo.v03r06.csv", "header");
  TableRow tempRow = table.getRow(1);  // Gets the second row (index 1)
  previd = tempRow.getString("Serial_Num");

  for (TableRow row : table.rows()) {
    id = row.getString("Serial_Num");
    if(!(id.equals(previd))){
      counter++;
    }
    previd = id;
  }
  
  dotcolor = (color[]) expand(dotcolor, counter+1);
  
  for (int i =0; i<dotcolor.length; i++){
    dotcolor[i] = color(random(255),random(255),random(255),50);
  }  
}

void draw(){
  map.draw();
  counter = 0;
  
  TableRow tempRow = table.getRow(1);  // Gets the second row (index 1)
  previd = tempRow.getString("Serial_Num");
  prevlat = tempRow.getFloat("Latitude");
  prevlon = tempRow.getFloat("Longitude");
  
  for (TableRow row : table.rows()) {
    
    id = row.getString("Serial_Num");
    if(!(id.equals(previd))){
      counter++;
      prevlat = row.getFloat("Latitude");
      prevlon = row.getFloat("Longitude");
    }
    
    previd = id;
    
    lat = row.getFloat("Latitude");
    lon = row.getFloat("Longitude");
    
    Location prevLocation = new Location(prevlat,prevlon);
    prevMarker = new SimplePointMarker(prevLocation);
    ScreenPosition prevPos = prevMarker.getScreenPosition(map);
    
    Location currentLocation = new Location(lat,lon);
    currentMarker = new SimplePointMarker(currentLocation);
    ScreenPosition currentPos = currentMarker.getScreenPosition(map);
    
    stroke(dotcolor[counter]);
    strokeWeight(1);
    line(prevPos.x,prevPos.y,currentPos.x,currentPos.y);
    
    prevlat = lat;
    prevlon = lon;
  }
}
