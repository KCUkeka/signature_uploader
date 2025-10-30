import 'dart:io';
import 'package:desktop_updater/updater_controller.dart';
import 'package:desktop_updater/widget/update_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

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
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_59659_29273_51238\webapps\mobiledoc\jsp\catalog',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_59659_29273_51238\webapps\mobiledoc\jsp\catalog\xml',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_59659_29273_51238\webapps\mobiledoc\jsp\catalog\xml\labs',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_59659_29273_51238\webapps\mobiledoc\practicedata\catalogimages',
    r'\\roxb-ecwapp2\d$\eClinicalWorks\tomcat8_59659_29273_51238\webapps\mobiledoc\xsl\progressnotes',
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
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat8_10887_74982_71303\webapps\mobiledoc\jsp\catalog',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat8_10887_74982_71303\webapps\mobiledoc\jsp\catalog\xml',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat8_10887_74982_71303\webapps\mobiledoc\jsp\catalog\xml\labs',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat8_10887_74982_71303\webapps\mobiledoc\practicedata\catalogimages',
    r'\\roxb-ecwapp3\d$\eClinicalWorks\tomcat8_10887_74982_71303\webapps\mobiledoc\xsl\progressnotes',
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

  // --- desktop_updater controller ---
  late DesktopUpdaterController _desktopUpdaterController;

  @override
  void initState() {
    super.initState();

    // Initialize the updater controller
    // Use the raw GitHub URL for your latest.json file
    _desktopUpdaterController = DesktopUpdaterController(
      appArchiveUrl: Uri.parse(
        'https://raw.githubusercontent.com/KCUkeka/signature_uploader/main/releases/app-archive.json',
      ),
    );

    // Auto-check on launch
    _autoCheckForUpdates();
  }

  Future<void> _autoCheckForUpdates() async {
    try {
      await _desktopUpdaterController.checkVersion();
      // If needUpdate becomes true, the DesktopUpdateWidget will show UI automatically
    } catch (e) {
      debugPrint('Auto update check failed: $e');
    }
  }

  // Manual check (call from button)
  Future<void> _manualCheckAndMaybeDownload({
    bool showSnackbars = false,
  }) async {
    try {
      // First check if there's an update available
      await _desktopUpdaterController.checkVersion();

      if (_desktopUpdaterController.needUpdate) {
        // If update is needed, you can download it
        await _desktopUpdaterController.downloadUpdate();

        if (showSnackbars && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Update downloaded! Restart to apply."),
            ),
          );
        }
      } else {
        if (showSnackbars && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You're on the latest version!")),
          );
        }
      }
    } catch (e) {
      if (showSnackbars && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Update check failed: $e")));
      }
      debugPrint("Manual update check failed: $e");
    }
  }

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
            child: Text('Upload Providers Signature TEST'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.system_update),
              tooltip: 'Check for Updates',
              onPressed:
                  () => _manualCheckAndMaybeDownload(showSnackbars: true),
            ),
          ],
        ),
      ),
      body: DesktopUpdateWidget(
        controller: _desktopUpdaterController,
        child: Center(
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
                                final renamed = selectedFile!.renameSync(
                                  newPath,
                                );
                                setState(() {
                                  selectedFile = renamed;
                                  statusMessage =
                                      '✅ Renamed to ${p.basename(newPath)}';
                                });
                              } catch (e) {
                                setState(() {
                                  statusMessage =
                                      '❌ Failed to rename image: $e';
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
                                                    text:
                                                        fixedServerPaths[index],
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
                                                        fixedServerPaths
                                                            .removeAt(index);
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
                                              fixedServerPaths.add(
                                                value.trim(),
                                              );
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
                                    onPressed:
                                        () => Navigator.of(context).pop(),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}