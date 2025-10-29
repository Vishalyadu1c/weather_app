package com.example.weather_app

import android.Manifest
import android.content.pm.PackageManager
import android.location.Geocoder
import android.location.Location
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.weather_app"
    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getCurrentLocation") {
                    getCurrentLocation(result)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun getCurrentLocation(result: MethodChannel.Result) {
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                1001
            )
            result.error("PERMISSION_DENIED", "Location permission not granted", null)
            return
        }

        fusedLocationClient.lastLocation
            .addOnSuccessListener { location: Location? ->
                if (location != null) {
                    val geocoder = Geocoder(this, Locale.getDefault())
                    val addresses = geocoder.getFromLocation(location.latitude, location.longitude, 1)
                    val address = addresses?.firstOrNull()
                    val cityName = address?.locality ?: "Unknown City"
                    val areaName = address?.subLocality ?: "Unknown Area"
                    val fullAddress = address?.getAddressLine(0) ?: "Unknown Address"

                    val data = mapOf(
                        "latitude" to location.latitude,
                        "longitude" to location.longitude,
                        "city" to cityName,
                        "area" to areaName,
                        "address" to fullAddress
                    )
                    result.success(data)
                } else {
                    result.error("LOCATION_ERROR", "Unable to get location", null)
                }
            }
            .addOnFailureListener {
                result.error("LOCATION_ERROR", "Failed to get location", it.message)
            }
    }
}

