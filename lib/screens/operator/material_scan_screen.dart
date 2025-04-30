import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../providers/app_state.dart';
import '../../models/material.dart';

class MaterialScanScreen extends StatefulWidget {
  const MaterialScanScreen({super.key});

  @override
  State<MaterialScanScreen> createState() => _MaterialScanScreenState();
}

class _MaterialScanScreenState extends State<MaterialScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Material? scannedMaterial;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        final materialId = scanData.code!;
        final material = context.read<AppState>().materials.firstWhere(
          (m) => m.id == materialId,
          orElse: () => throw Exception('Material not found'),
        );
        
        setState(() {
          scannedMaterial = material;
        });
        
        // Stop scanning after finding the material
        controller.pauseCamera();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Material'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: scannedMaterial != null
                ? Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Material: ${scannedMaterial!.name}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Unit Cost: \$${scannedMaterial!.unitCost}'),
                          Text('Unit Type: ${scannedMaterial!.unitType}'),
                          Text('Current Stock: ${scannedMaterial!.currentStock}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to usage log screen with material
                              Navigator.pop(context, scannedMaterial);
                            },
                            child: const Text('Log Usage'),
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      'Scan a material QR code',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller?.resumeCamera();
          setState(() {
            scannedMaterial = null;
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
} 