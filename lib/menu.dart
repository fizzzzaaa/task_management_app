import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Import other screens and classes
import 'completed_screen.dart';

// Function to show a message after export
void showExportMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Export Status"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

class MenuDrawer extends StatelessWidget {
  final Function toggleTheme; // The toggleTheme function will be passed from the parent widget

  // Constructor to receive the toggleTheme function
  MenuDrawer({required this.toggleTheme});

  // Initialize the downloader
  Future<void> _downloadFile(String url, String filename) async {
    final dir = await getExternalStorageDirectory();
    final filePath = "${dir!.path}/$filename";

    // Start the download
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir.path,
      fileName: filename,
      showNotification: true, // Show download notification
      openFileFromNotification: true, // Open file after download
    );

    print('Download task started with id: $taskId');
  }

  // Function to create PDF report and trigger download
  Future<void> createPdfReport(BuildContext context) async {
    final pdf = pw.Document();

    // Add a page to the document
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text('This is your report!', style: pw.TextStyle(fontSize: 40)),
        ); // Simple text for now
      },
    )) ;

    try {
      final outputDirectory = await getExternalStorageDirectory();  // Get external directory
      final filePath = "${outputDirectory!.path}/report.pdf"; // Define file path

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save()); // Save PDF to file

      // Trigger the download of the PDF
      _downloadFile(filePath, 'report.pdf');

      // Show a success message
      showExportMessage(context, "PDF Exported Successfully!");
    } catch (e) {
      showExportMessage(context, "Failed to export PDF: $e");
    }
  }

  // Function to create CSV report and trigger download
  Future<void> createCsvReport(BuildContext context) async {
    try {
      final csvData = "Column1,Column2,Column3\n1,2,3\n4,5,6"; // Simple CSV data

      final outputDirectory = await getExternalStorageDirectory(); // Get external directory
      final filePath = "${outputDirectory!.path}/report.csv"; // Define file path

      final file = File(filePath);
      await file.writeAsString(csvData); // Save CSV data to file

      // Trigger the download of the CSV
      _downloadFile(filePath, 'report.csv');

      // Show a success message
      showExportMessage(context, "CSV Exported Successfully!");
    } catch (e) {
      showExportMessage(context, "Failed to export CSV: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple[800], // Matching theme color
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white), // Back arrow icon
                  onPressed: () {
                    Navigator.pop(context); // Close the drawer when clicked
                  },
                ),
                SizedBox(width: 10), // Some spacing between the icon and the text
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          // Theme switcher
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Theme'),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark, // Check if current theme is dark
              onChanged: (value) {
                toggleTheme(); // Call the toggle theme function passed from parent
              },
            ),
          ),
          // Navigate to CompletedScreen (Progress tracking)
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Progress'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompletedScreen(toggleTheme: toggleTheme)),
              ); // Navigate to progress tracking screen
            },
          ),
          // Export functionality
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Export As'),
            onTap: () {
              // Close the drawer
              Navigator.pop(context);

              // Show the dialog to select export type (PDF or CSV)
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Select Export Option"),
                    content: Text("Choose whether you want to export as PDF or CSV."),
                    actions: <Widget>[
                      // Export as PDF
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent, // Transparent background
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                          side: BorderSide(color: Colors.blue), // Optional: border color
                        ),
                        icon: Icon(Icons.picture_as_pdf, color: Colors.blue), // PDF Icon
                        label: Text("Export as PDF", style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          // Handle PDF export logic here
                          Navigator.pop(context); // Close the dialog
                          createPdfReport(context); // Call PDF export function
                        },
                      ),
                      SizedBox(height: 10),
                      // Export as CSV
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent, // Transparent background
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                          side: BorderSide(color: Colors.green), // Optional: border color
                        ),
                        icon: Icon(Icons.table_chart, color: Colors.green), // CSV Icon
                        label: Text("Export as CSV", style: TextStyle(color: Colors.green)),
                        onPressed: () {
                          // Handle CSV export logic here
                          Navigator.pop(context); // Close the dialog
                          createCsvReport(context); // Call CSV export function
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
