import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(RestartWidget(child: SignatureUploaderApp()));
}

class RestartWidget extends StatefulWidget {
  final Widget child;
  RestartWidget({required this.child});

  static void restartApp(BuildContext context) {
    final _RestartWidgetState? state =
        context.findAncestorStateOfType<_RestartWidgetState>();
    state?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: widget.child);
  }
}

class SignatureUploaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signature Uploader',
      home: SignatureHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SignatureHomePage extends StatefulWidget {
  @override
  _SignatureHomePageState createState() => _SignatureHomePageState();
}

class _SignatureHomePageState extends State<SignatureHomePage> {
  File? selectedFile;
  String statusMessage = '';
  final TextEditingController _renameController = TextEditingController();
  String _currentVersion = '1.0.1'; // Fallback version
  bool _checkingForUpdates = false;

  // Hardcoded destinations
  final List<String> fixedServerPaths = [
    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9_9090\webapps\mobiledoc\jsp\catalog',
    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9_9090\webapps\mobiledoc\jsp\catalog\xml',
    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9_9090\webapps\mobiledoc\jsp\catalog\xml\labs',
    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9_9090\webapps\mobiledoc\practicedata\catalogimages',
    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9_9090\webapps\mobiledoc\xsl\progressnotes',

    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9\webapps\mobiledoc\jsp\catalog',
    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9\webapps\mobiledoc\jsp\catalog\xml',
    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9\webapps\mobiledoc\jsp\catalog\xml\labs',
    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9\webapps\mobiledoc\practicedata\catalogimages',
    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9\webapps\mobiledoc\xsl\progressnotes',

    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\jsp\catalog',
    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\jsp\catalog\xml',
    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\jsp\catalog\xml\labs',
    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\practicedata\catalogimages',
    r'\\roxb-ecwapp1\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\xsl\progressnotes',
    
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_59659_29273_51238_8080\webapps\mobiledoc\jsp\catalog',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_59659_29273_51238_8080\webapps\mobiledoc\jsp\catalog\xml',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_59659_29273_51238_8080\webapps\mobiledoc\jsp\catalog\xml\labs',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_59659_29273_51238_8080\webapps\mobiledoc\practicedata\catalogimages',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_59659_29273_51238_8080\webapps\mobiledoc\xsl\progressnotes',

    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_9090_15278_45914_15173\webapps\mobiledoc\jsp\catalog',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_9090_15278_45914_15173\webapps\mobiledoc\jsp\catalog\xml',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_9090_15278_45914_15173\webapps\mobiledoc\jsp\catalog\xml\labs',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_9090_15278_45914_15173\webapps\mobiledoc\practicedata\catalogimages',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_9090_15278_45914_15173\webapps\mobiledoc\xsl\progressnotes',

    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\jsp\catalog',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\jsp\catalog\xml',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\jsp\catalog\xml\labs',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\practicedata\catalogimages',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\xsl\progressnotes',

    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat8_9090_65002_77755\webapps\mobiledoc\jsp\catalog',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat8_9090_65002_77755\webapps\mobiledoc\jsp\catalog\xml',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat8_9090_65002_77755\webapps\mobiledoc\jsp\catalog\xml\labs',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat8_9090_65002_77755\webapps\mobiledoc\practicedata\catalogimages',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat8_9090_65002_77755\webapps\mobiledoc\xsl\progressnotes',

    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat9_8080\webapps\mobiledoc\jsp\catalog',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat9_8080\webapps\mobiledoc\jsp\catalog\xml',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat9_8080\webapps\mobiledoc\jsp\catalog\xml\labs',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat9_8080\webapps\mobiledoc\practicedata\catalogimages',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat9_8080\webapps\mobiledoc\xsl\progressnotes',
    
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\jsp\catalog',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\jsp\catalog\xml',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\jsp\catalog\xml\labs',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\practicedata\catalogimages',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat9_10010\webapps\mobiledoc\xsl\progressnotes',
  ];

  final Map<String, String> providerDestinations = {
    'Docs': r'R:\Signatures\Docs',
    "PA's": r'R:\Signatures\PAs',
    'Therapy': r'R:\Signatures\Therapy',
    'Other': '',
  };

  String selectedProviderFolder = 'Docs';
  bool forceCopy = false;

  @override
  void initState() {
    super.initState();
    

/////////////////////// Removed along with update method. /////////////////////////////////

    // _initializePackageInfo(); // This sets _currentVersion dynamically
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _autoCheckForUpdates();
    // }
    // );
  }

  // This method is to get the version info
  Future<void> _initializePackageInfo() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _currentVersion = packageInfo.version;
      });
    } catch (e) {
      debugPrint('Failed to get package info: $e');
      // Keep the fallback version
    }
  }

  

/////////////////////// Removed update method. /////////////////////////////////


  // Future<void> _autoCheckForUpdates() async {
  //   try {
  //     await _checkForUpdates(showDialogIfUpToDate: false);
  //   } catch (e) {
  //     debugPrint('Auto update check failed: $e');
  //   }
  // }
  // Future<void> _manualCheckForUpdates() async {
  //   await _checkForUpdates(showDialogIfUpToDate: true);
  // }

  // Future<void> _checkForUpdates({bool showDialogIfUpToDate = true}) async {
  //   if (_checkingForUpdates) return;

  //   setState(() {
  //     _checkingForUpdates = true;
  //   });

  //   try {
  //     final client = HttpClient();
  //     final request = await client.getUrl(
  //       Uri.parse(
  //         'https://raw.githubusercontent.com/KCUkeka/signature_uploader/main/releases/app-archive.json',
  //       ),
  //     );
  //     final response = await request.close();

  //     if (response.statusCode != 200) {
  //       throw HttpException(
  //         'Failed to fetch update info: ${response.statusCode}',
  //       );
  //     }

  //     final jsonStr = await response.transform(utf8.decoder).join();
  //     final jsonData = jsonDecode(jsonStr);

  //     final latestVersion = jsonData['items'][0]['version'];

  //     // Use the dynamically fetched current version from package_info_plus
  //     if (_isNewerVersion(latestVersion, _currentVersion)) {
  //       final downloadUrl = jsonData['items'][0]['url'];
  //       final changes = jsonData['items'][0]['changes'] as List;
  //       _showUpdateDialog(downloadUrl, latestVersion, changes);
  //     } else {
  //       if (showDialogIfUpToDate && mounted) {
  //         _showUpToDateDialog();
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text("Update check failed: $e")));
  //     }
  //     debugPrint("Update check failed: $e");
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _checkingForUpdates = false;
  //       });
  //     }
  //   }
  // }

  bool _isNewerVersion(String latest, String current) {
    try {
      final latestParts = latest.split('.').map(int.parse).toList();
      final currentParts = current.split('.').map(int.parse).toList();

      for (int i = 0; i < latestParts.length; i++) {
        if (i >= currentParts.length) return true;
        if (latestParts[i] > currentParts[i]) return true;
        if (latestParts[i] < currentParts[i]) return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void _showUpdateDialog(String downloadUrl, String version, List changes) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Update Available'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Version $version is available!',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('What\'s new:'),
                  const SizedBox(height: 5),
                  ...changes
                      .map(
                        (change) => Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                          child: Text('• ${change['message']}'),
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 10),
                  const Text(
                    'Click "Download Update" to get the latest version.',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Later'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _launchDownload(downloadUrl);
                },
                child: const Text('Download Update'),
              ),
            ],
          ),
    );
  }

  void _showUpToDateDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Up to Date'),
            content: const Text(
              'You are using the latest version of Signature Uploader.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _launchDownload(String url) async {
    try {
      final uri = Uri.parse(url);

      // Check if the URL can be launched
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Opening download page...'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to open download: $e')));
      }
    }
  }

  // ... [Keep all your existing methods: pickImage, clearSignature, checkImage, resizeImage, copyToDestination] ...

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'bmp',
        'webp',
        'tiff',
        'tif',
        'jfif',
      ],
    );
    if (result != null && result.files.single.path != null) {
      File imageFile = File(result.files.single.path!);
      checkImage(imageFile);
    }
  }

  void clearSignature() {
    setState(() {
      selectedFile = null;
      _renameController.clear();
      statusMessage = 'Signature cleared';
    });
  }

  void checkImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      setState(() {
        statusMessage = '❌ Failed to read the image file.';
      });
      return;
    }
    final width = decoded.width;
    final height = decoded.height;
    if (width == 180 && height == 100) {
      setState(() {
        selectedFile = imageFile;
        statusMessage = '✅ Image is correctly sized: 180x100';
      });
    } else {
      setState(() {
        selectedFile = imageFile;
        statusMessage = '⚠️ Image is ${width}x${height}. Resize required.';
      });
    }
  }

  Future<void> resizeImage() async {
    if (selectedFile == null) return;
    final bytes = await selectedFile!.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      setState(() {
        statusMessage = '❌ Failed to read the image file.';
      });
      return;
    }
    final resized = img.copyResize(decoded, width: 180, height: 100);
    final newPath = p.setExtension(selectedFile!.path, '.jpg');
    final resizedFile = File(newPath);
    await resizedFile.writeAsBytes(img.encodeJpg(resized));
    setState(() {
      selectedFile = resizedFile;
      statusMessage =
          '✅ Image resized to 180x100 and saved as ${p.basename(newPath)}';
    });
  }

  void copyToDestination() async {
    if (selectedFile == null) {
      setState(() {
        statusMessage = '⚠️ No file selected.';
      });
      return;
    }
    if (statusMessage.contains('Resize required')) {
      await resizeImage(); // This will overwrite the selectedFile
      if (!statusMessage.contains('180x100')) {
        setState(() {
          statusMessage = '❌ Resize failed. Aborting copy.';
        });
        return;
      }
    }

    // Ask if user wants to force copy if we detect duplicates
    bool hasDuplicates = false;
    final List<String> allTargets = [
      ...fixedServerPaths,
      providerDestinations[selectedProviderFolder] ?? '',
    ];

    // First check if any duplicates exist
    for (final path in allTargets) {
      if (path.isEmpty) continue;
      final newFilePath = p.join(path, p.basename(selectedFile!.path));
      final destFile = File(newFilePath);
      if (destFile.existsSync()) {
        hasDuplicates = true;
        break;
      }
    }

    if (hasDuplicates && !forceCopy) {
      final shouldForceCopy = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Duplicate Files Found'),
              content: const Text(
                'Some destinations already contain this file. Overwrite all duplicates?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Skip Duplicates'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Overwrite All',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
      );
      if (shouldForceCopy == true) {
        setState(() => forceCopy = true);
      }
    }

    List<String> successfulCopies = [];
    List<String> overwrittenCopies = [];
    List<String> skippedDuplicates = [];
    List<String> failedCopies = [];

    for (final path in allTargets) {
      if (path.isEmpty) continue;
      try {
        final destinationDir = Directory(path);
        if (!destinationDir.existsSync()) {
          destinationDir.createSync(recursive: true);
        }
        final newFilePath = p.join(path, p.basename(selectedFile!.path));
        final destFile = File(newFilePath);
        if (destFile.existsSync()) {
          if (forceCopy) {
            await selectedFile!.copy(newFilePath);
            overwrittenCopies.add(path);
          } else {
            skippedDuplicates.add(path);
          }
          continue;
        }
        await selectedFile!.copy(newFilePath);
        successfulCopies.add(path);
      } catch (e) {
        failedCopies.add('$path\n$e');
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Copy Summary'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (successfulCopies.isNotEmpty) ...[
                  const Text('✅ Copied to:'),
                  ...successfulCopies.map(
                    (p) => Text(
                      p,
                      style: const TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (overwrittenCopies.isNotEmpty) ...[
                  const Text('🔄 Overwritten in:'),
                  ...overwrittenCopies.map(
                    (p) => Text(
                      p,
                      style: const TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (skippedDuplicates.isNotEmpty) ...[
                  const Text('⚠️ Skipped (duplicate exists):'),
                  ...skippedDuplicates.map(
                    (p) => Text(
                      p,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (failedCopies.isNotEmpty) ...[
                  const Text('❌ Failed to copy:'),
                  ...failedCopies.map(
                    (p) => Text(
                      p,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );

    setState(() {
      statusMessage =
          '✅ Copy process completed. ${successfulCopies.length} copied, '
          '${overwrittenCopies.length} overwritten, '
          '${skippedDuplicates.length} skipped, '
          '${failedCopies.length} failed.';
    });
  }

  // -----------------------------------------------------------------Body-----------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text('Upload Providers Signature'),
          ),
          actions: [
            // Removed update method

            // IconButton(
            //   icon:
            //       _checkingForUpdates
            //           ? const SizedBox(
            //             width: 20,
            //             height: 20,
            //             child: CircularProgressIndicator(strokeWidth: 2),
            //           )
            //           : const Icon(Icons.system_update),
            //   tooltip: 'Check for Updates',
            //   onPressed: _checkingForUpdates ? null : _manualCheckForUpdates,
            // ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: pickImage,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Pick Signature Image'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: selectedFile != null ? clearSignature : null,
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear Signature'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (selectedFile != null) ...[
                  Text(
                    'Selected: ${p.basename(selectedFile!.path)}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _renameController,
                          decoration: const InputDecoration(
                            labelText: 'Rename Image',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          final value = _renameController.text.trim();
                          if (value.isNotEmpty) {
                            final dir = p.dirname(selectedFile!.path);
                            final ext = p.extension(selectedFile!.path);
                            final newPath = p.join(dir, '$value$ext');
                            try {
                              final renamed = selectedFile!.renameSync(newPath);
                              setState(() {
                                selectedFile = renamed;
                                statusMessage =
                                    '✅ Renamed to ${p.basename(newPath)}';
                              });
                            } catch (e) {
                              setState(() {
                                statusMessage = '❌ Failed to rename image: $e';
                              });
                            }
                          }
                        },
                        child: const Text('Rename'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Image.file(selectedFile!, height: 100),
                  const SizedBox(height: 20),
                ],
                Text(
                  statusMessage,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                if (statusMessage.contains('Resize required')) ...[
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: resizeImage,
                    icon: const Icon(Icons.crop),
                    label: const Text('Resize to 180x100'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setStateDialog) {
                            final TextEditingController newPathController =
                                TextEditingController();
                            return AlertDialog(
                              title: const Text('Fixed Paths'),
                              content: SizedBox(
                                width: double.maxFinite,
                                height: 400,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Scrollbar(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: fixedServerPaths.length,
                                          itemBuilder: (context, index) {
                                            final controller =
                                                TextEditingController(
                                                  text: fixedServerPaths[index],
                                                );
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller: controller,
                                                    onSubmitted: (value) {
                                                      setStateDialog(() {
                                                        fixedServerPaths[index] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    setStateDialog(() {
                                                      fixedServerPaths.removeAt(
                                                        index,
                                                      );
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      controller: newPathController,
                                      decoration: const InputDecoration(
                                        hintText: 'Add new path',
                                      ),
                                      onSubmitted: (value) {
                                        if (value.trim().isNotEmpty) {
                                          setStateDialog(() {
                                            fixedServerPaths.add(value.trim());
                                            newPathController.clear();
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setStateDialog(() {
                                      fixedServerPaths.clear();
                                    });
                                  },
                                  child: const Text(
                                    'Clear All',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.list),
                  label: const Text('Show Paths'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Save signature to:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedProviderFolder,
                  items:
                      providerDestinations.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Tooltip(
                            message:
                                entry.value.isEmpty
                                    ? 'No path assigned'
                                    : entry.value,
                            child: Text(entry.key),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedProviderFolder = value;
                      });
                    }
                  },
                ),
                if (selectedProviderFolder == 'Other') ...[
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      String? selectedPath =
                          await FilePicker.platform.getDirectoryPath();
                      if (selectedPath != null) {
                        setState(() {
                          providerDestinations['Other'] = selectedPath;
                        });
                      }
                    },
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Select Folder'),
                  ),
                  if ((providerDestinations['Other'] ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Selected: ${providerDestinations['Other']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                ],
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: copyToDestination,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy to Destinations'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: forceCopy ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => RestartWidget.restartApp(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart App'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
