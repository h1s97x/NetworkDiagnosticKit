package dev.fluttercommunity.network_diagnostic_kit

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.wifi.WifiManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.InetAddress
import java.net.URL

/** NetworkDiagnosticKitPlugin */
class NetworkDiagnosticKitPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "network_diagnostic_kit")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "ping" -> {
                val host = call.argument<String>("host") ?: "google.com"
                val count = call.argument<Int>("count") ?: 4
                result.success(ping(host, count))
            }
            "traceRoute" -> {
                val host = call.argument<String>("host") ?: "google.com"
                result.success(traceRoute(host))
            }
            "dnsLookup" -> {
                val domain = call.argument<String>("domain") ?: "google.com"
                result.success(dnsLookup(domain))
            }
            "getNetworkInfo" -> {
                result.success(getNetworkInfo())
            }
            "getWifiInfo" -> {
                result.success(getWifiInfo())
            }
            "testHttpConnection" -> {
                val url = call.argument<String>("url") ?: "https://www.google.com"
                result.success(testHttpConnection(url))
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun ping(host: String, count: Int): Map<String, Any?> {
        val results = mutableListOf<Map<String, Any?>>()
        var successCount = 0
        var totalMs = 0L

        try {
            for (i in 1..count) {
                val start = System.currentTimeMillis()
                val address = InetAddress.getByName(host)
                val reachable = address.isReachable(5000) // 5 second timeout
                val elapsed = System.currentTimeMillis() - start

                if (reachable) {
                    successCount++
                    totalMs += elapsed
                }

                results.add(mapOf(
                    "host" to host,
                    "sequence" to i,
                    "time" to elapsed,
                    "reachable" to reachable
                ))
            }

            val avgMs = if (successCount > 0) totalMs / successCount else 0L
            val packetLoss = ((count - successCount).toDouble() / count) * 100

            return mapOf(
                "host" to host,
                "count" to count,
                "successCount" to successCount,
                "packetLossPercentage" to packetLoss,
                "averageTime" to avgMs,
                "results" to results
            )
        } catch (e: Exception) {
            return mapOf(
                "error" to e.message,
                "results" to results
            )
        }
    }

    private fun traceRoute(host: String): Map<String, Any?> {
        val hops = mutableListOf<Map<String, Any?>>()
        
        try {
            val process = Runtime.getRuntime().exec("traceroute -m 30 $host")
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            
            var line: String?
            while (reader.readLine().also { line = it } != null) {
                // Parse traceroute output
                if (line!!.isNotEmpty()) {
                    val hopData = parseTracerouteLine(line!!)
                    if (hopData != null) {
                        hops.add(hopData)
                    }
                }
            }
            
            process.waitFor()
            
            return mapOf(
                "host" to host,
                "hops" to hops
            )
        } catch (e: Exception) {
            return mapOf(
                "error" to e.message,
                "hops" to hops
            )
        }
    }

    private fun parseTracerouteLine(line: String): Map<String, Any?>? {
        try {
            val parts = line.trim().split("\\s+".toRegex())
            if (parts.size >= 2 && parts[0].matches(Regex("\\d+"))) {
                return mapOf(
                    "hop" to parts[0].toInt(),
                    "ip" to if (parts.size > 1) parts[1] else null,
                    "time" to if (parts.size > 2) parts[2] else null
                )
            }
        } catch (e: Exception) {
            // Skip invalid lines
        }
        return null
    }

    private fun dnsLookup(domain: String): Map<String, Any?> {
        try {
            val addresses = InetAddress.getAllByName(domain)
            val ipList = addresses.map { it.hostAddress }
            
            return mapOf(
                "domain" to domain,
                "ipAddresses" to ipList
            )
        } catch (e: Exception) {
            return mapOf(
                "domain" to domain,
                "error" to e.message
            )
        }
    }

    private fun getNetworkInfo(): Map<String, Any?> {
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val activeNetwork = connectivityManager.activeNetworkInfo
        
        if (activeNetwork != null) {
            val capabilities = connectivityManager.getNetworkCapabilities(connectivityManager.activeNetwork)
            val transport = when {
                capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) == true -> "wifi"
                capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) == true -> "cellular"
                capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) == true -> "ethernet"
                else -> "unknown"
            }
            
            return mapOf(
                "isConnected" to activeNetwork.isConnected,
                "isConnectedOrConnecting" to activeNetwork.isConnectedOrConnecting,
                "type" to activeNetwork.type,
                "typeName" to activeNetwork.typeName,
                "transport" to transport,
                "isAvailable" to activeNetwork.isAvailable,
                "isFailover" to activeNetwork.isFailover,
                "isRoaming" to activeNetwork.isRoaming
            )
        }
        
        return mapOf(
            "isConnected" to false,
            "error" to "No active network"
        )
    }

    @Suppress("DEPRECATION")
    private fun getWifiInfo(): Map<String, Any?> {
        try {
            val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
            val wifiInfo = wifiManager.connectionInfo
            
            return mapOf(
                "ssid" to wifiInfo.ssid?.replace("\"", ""),
                "bssid" to wifiInfo.bssid,
                "macAddress" to wifiInfo.macAddress,
                "signalStrength" to wifiInfo.rssi,
                "linkSpeed" to wifiInfo.linkSpeed,
                "frequency" to wifiInfo.frequency,
                "ipAddress" to android.net.Formatter.formatIpAddress(wifiInfo.ipAddress),
                "networkId" to wifiInfo.networkId
            )
        } catch (e: Exception) {
            return mapOf(
                "error" to e.message
            )
        }
    }

    private fun testHttpConnection(urlStr: String): Map<String, Any?> {
        try {
            val start = System.currentTimeMillis()
            val url = URL(urlStr)
            val connection = url.openConnection() as HttpURLConnection
            connection.requestMethod = "GET"
            connection.connectTimeout = 10000
            connection.readTimeout = 10000
            
            val responseCode = connection.responseCode
            val elapsed = System.currentTimeMillis() - start
            
            return mapOf(
                "url" to urlStr,
                "statusCode" to responseCode,
                "success" to responseCode in 200..299,
                "time" to elapsed
            )
        } catch (e: Exception) {
            return mapOf(
                "url" to urlStr,
                "error" to e.message,
                "success" to false
            )
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
