package com.softwin_ci.tax_collect

import android.os.Bundle
import android.os.RemoteException
import android.util.Log
import androidx.annotation.NonNull
import com.wisepos.smartpos.InitPosSdkListener
import com.wisepos.smartpos.WisePosSdk
import com.wisepos.smartpos.printer.PrinterListener
import com.wisepos.smartpos.printer.TextInfo
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    lateinit var wisePosSdk: WisePosSdk

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        wisePosSdk = WisePosSdk.getInstance()
        wisePosSdk!!.initPosSdk(this, object : InitPosSdkListener {
            override fun onInitPosSuccess() {
                Log.d("sdkdemo", "initPosSdk: success!")
            }

            override fun onInitPosFail(i: Int) {
                Log.d("sdkdemo", "initPosSdk: fail!")
            }
        })
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "androidChannel"
        ).setMethodCallHandler { call, result ->
            if (call.method == "wiseasyPrint") {
                val data = call.arguments as String  // texte à imprimer
                printReceipt(data)
            }
        }
    }

    private fun printReceipt(data: String) {
        val PRINT_STYLE_LEFT = 0x01
        val PRINT_STYLE_CENTER = 0x02
        val PRINT_STYLE_RIGHT = 0x04

        try {
            var mPrinter = wisePosSdk.getPrinter()

            // 1. Initialiser l'imprimante
            mPrinter.initPrinter()

            // 2. Niveau de gris (1 = normal)
            val ret = mPrinter.setGrayLevel(1)

            // 3. Vérifier le statut
            val map = mPrinter.getPrinterStatus()

            // 4. Ajouter le logo (depuis assets/)
//            val inputStream = assets.open("logo-setbc-.png")
//            val bitmap = BitmapFactory.decodeStream(inputStream)
//            mPrinter.addPicture(PRINT_STYLE_CENTER, bitmap)
//            inputStream.close()

            // 5. Espacement après logo
            val spacingInfo = TextInfo()
            spacingInfo.setAlign(PRINT_STYLE_CENTER)
            spacingInfo.setFontSize(16)
            spacingInfo.setText("\n")
            mPrinter.addSingleText(spacingInfo)

            // 6. Texte principal (reçu)
            val textInfo = TextInfo()
            textInfo.setAlign(PRINT_STYLE_LEFT)
            textInfo.setFontSize(22)
            textInfo.setText(data)        // ← contenu envoyé depuis Flutter
            mPrinter.addSingleText(textInfo)

            // 7. Ligne de séparation
            textInfo.setAlign(PRINT_STYLE_CENTER)
            textInfo.setFontSize(22)
            textInfo.setText("_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _")
            mPrinter.addSingleText(textInfo)

            // 8. Lancer l'impression
            mPrinter.startPrinting(Bundle(), object : PrinterListener {
                override fun onError(i: Int) { /* gérer l'erreur */
                }

                override fun onFinish() {
                    mPrinter.feedPaper(24)  // avancer le papier
                }

                override fun onReport(i: Int) { /* réservé */
                }
            })

        } catch (e: RemoteException) {
            e.printStackTrace()
        }
    }
}