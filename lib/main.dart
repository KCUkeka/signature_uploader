import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

void main() {
  runApp(SignatureUploaderApp());
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
  };

  String selectedProviderFolder = 'Docs';

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

  void resizeImage() async {
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
    final resizedFile = File(newPath)..writeAsBytesSync(img.encodeJpg(resized));

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

    List<String> successfulCopies = [];
    List<String> skippedDuplicates = [];
    List<String> failedCopies = [];

    final List<String> allTargets = [
      ...fixedServerPaths,
      providerDestinations[selectedProviderFolder] ?? '',
    ];

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
          skippedDuplicates.add(path);
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
          title: Text('Copy Summary'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (successfulCopies.isNotEmpty) ...[
                  Text('✅ Copied to:'),
                  ...successfulCopies.map(
                    (p) => Text(
                      p,
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
                if (skippedDuplicates.isNotEmpty) ...[
                  Text('⚠️ Skipped (duplicate exists):'),
                  ...skippedDuplicates.map(
                    (p) => Text(
                      p,
                      style: TextStyle(color: Colors.orange, fontSize: 12),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
                if (failedCopies.isNotEmpty) ...[
                  Text('❌ Failed to copy:'),
                  ...failedCopies.map(
                    (p) => Text(
                      p,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );

    setState(() {
      statusMessage =
          '✅ Copy process completed. ${successfulCopies.length} copied, ${skippedDuplicates.length} skipped, ${failedCopies.length} failed.';
    });
  }

  // ---------------------------------Body------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text('Upload Providers Signature'),
          ),
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
                      icon: Icon(Icons.upload_file),
                      label: Text('Pick Signature Image'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: selectedFile != null ? clearSignature : null,
                      icon: Icon(Icons.clear),
                      label: Text('Clear Signature'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (selectedFile != null) ...[
                  Text(
                    'Selected: ${p.basename(selectedFile!.path)}',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        child: TextField(
                          controller: _renameController,
                          decoration: InputDecoration(
                            labelText: 'Rename Image',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
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
                        child: Text('Rename'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Image.file(selectedFile!, height: 100),
                  SizedBox(height: 20),
                ],
                Text(
                  statusMessage,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                if (statusMessage.contains('Resize required')) ...[
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: resizeImage,
                    icon: Icon(Icons.crop),
                    label: Text('Resize to 180x100'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
                SizedBox(height: 30),
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
                              title: Text('Fixed Server Paths'),
                              content: Container(
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
                                                  icon: Icon(
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
                                      decoration: InputDecoration(
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
                                  child: Text('Close'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.list),
                  label: Text('Show Server Paths'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Copy to provider destination:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedProviderFolder,
                  items:
                      providerDestinations.keys.map((dest) {
                        return DropdownMenuItem(value: dest, child: Text(dest));
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedProviderFolder = value;
                      });
                    }
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: copyToDestination,
                  icon: Icon(Icons.copy),
                  label: Text('Copy to All Destinations'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
