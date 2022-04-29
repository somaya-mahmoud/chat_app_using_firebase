

 //AIzaSyCra1oTpTy6tybHPsREubfROT0cq2ExIIE

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
 import 'package:responsive_sizer/responsive_sizer.dart';

class MapsScreen extends StatefulWidget {
   const MapsScreen({Key? key}) : super(key: key);

   @override
   _MapsScreenState createState() => _MapsScreenState();
 }

 class _MapsScreenState extends State<MapsScreen> {
   String street = "";
   @override
   void initState() {
     super.initState();
     if (defaultTargetPlatform == TargetPlatform.android) {
       AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
     }
   }

   Completer<GoogleMapController> _controller = Completer();

   static const CameraPosition _latLng = CameraPosition(
     target: LatLng(30.070482, 31.3424045),
     zoom: 15,
   );

   //30.070482,31.3424045,15z  senior steps
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: Stack(
         alignment: Alignment.center,
         children:[
           GoogleMap(
            markers: markers.values.toSet(),
           mapType: MapType.hybrid,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            initialCameraPosition: _latLng,
           onMapCreated: (GoogleMapController controller) {
             _controller.complete(controller);
           },

            onTap: (latLng) async {
               print(latLng);
               print(latLng.latitude);
               print(latLng.longitude);
              List<Placemark> placemarks = await placemarkFromCoordinates(
                  latLng.latitude,
                  latLng.latitude,
                  localeIdentifier: "ar");
               print(placemarks[0].toJson());
               street = placemarks[0].street!;
              addMarker(latLng,street);

           },
     ),
           Positioned(
             top: 10.h,
             child: Container(
               margin: EdgeInsets.all(20.sp),
               width: 70.w,
               height: 50,
               decoration: BoxDecoration(color: Colors.grey,
               borderRadius: BorderRadius.circular(15.sp)),
               child: Text(street),
             ),
           ),
           Positioned(
             bottom: 10.h,
             child: ElevatedButton(
                 onPressed: () {
             },
                 child: Text("Confirm Location",)),
           ),

     ],
       ),

     );
   }
Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

 addMarker(LatLng latLng,String street){
  // markers.clear(); or make id = 1 as following
  // markers.clear();
   var marker = Marker(
     markerId: MarkerId("1"),
     position: latLng,
     // icon: BitmapDescriptor.,
     infoWindow: InfoWindow(
        title: street,
      ),
   );
   markers[MarkerId("1")] = marker;

   setState(() {
   });
 }
 }




