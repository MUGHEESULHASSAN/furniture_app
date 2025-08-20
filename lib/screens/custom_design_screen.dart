import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BedCustomizerScreen extends StatefulWidget {
  const BedCustomizerScreen({super.key});
  @override
  State<BedCustomizerScreen> createState() => _BedCustomizerScreenState();
}

class _BedCustomizerScreenState extends State<BedCustomizerScreen> {
  int currentStep = 0;
  final List<String> bedBases = ["Ottoman", "Divan"];
  final List<String> headboards = [
    "Vertical Lines Standing",
    "Cubes Floor Standing",
    "Minimalist Floor Standing",
    "Chesterfield Standing",
    "Straight Circle Winged",
    "Cubed Small Headboard",
    "Horizontal Lined Small",
    "Modern Minimalists Small"
  ];
  final List<String> bedSizes = [
    "Single Bed",
    "Small Double Bed",
    "Double",
    "King Size",
    "Super King"
  ];
  final List<String> fabrics = [
    "Plush",
    "Wool",
    "Naples",
    "Linen",
    "Cricket Velvet",
    "Chenielle"
  ];
  final List<String> colors = ["Ivory", "Beige", "Pink", "Duck Egg", "White", "Silver", "Mink", "Midnight Blue", "Silver(light)", "Grey(light)", "Grey(dark)", "Green", "Turquoise", "Mustard", "Steel", "Camel", "Lilac", "Maroon", "Black"];

  String? selectedBase;
  String? selectedHeadboard;
  String? selectedSize;
  String? selectedFabric;
  String? selectedColor;

  late final List<Map<String, dynamic>> steps;

  @override
  void initState() {
    super.initState();
    selectedBase = bedBases[0]; // Ottoman
    selectedHeadboard = headboards[0]; // Vertical Lines Standing
    selectedSize = bedSizes[0]; // Single Bed
    selectedFabric = fabrics[0]; // Plush
    selectedColor = colors[0]; // Brown
    steps = [
      {
        "title": "Select Base",
        "subtitle": "Select your bed base",
        "options": bedBases,
        "onSelect": (val) => selectedBase = val
      },
      {
        "title": "Select Headboard",
        "subtitle": "Choose your bed headboard",
        "options": headboards,
        "onSelect": (val) => selectedHeadboard = val
      },
      {
        "title": "Select Size",
        "subtitle": "Choose your bed size",
        "options": bedSizes,
        "onSelect": (val) => selectedSize = val
      },
      {
        "title": "Select Fabric",
        "subtitle": "Choose your bed fabric",
        "options": fabrics,
        "onSelect": (val) => selectedFabric = val
      },
      {
        "title": "Select Color",
        "subtitle": "Choose your bed color",
        "options": colors,
        "onSelect": (val) => selectedColor = val
      },
    ];
  }
  String? get previewImage {
    switch (currentStep) {
      case 0: // Base selection
        if (selectedBase == "Ottoman") {
          return "assets/images/ottoman.jpg";
        } else {
          return "assets/images/divan.jpg";
        }
      case 1: // Headboard selection
        switch (selectedHeadboard) {
          case "Vertical Lines Standing":
            return "assets/images/headboard_vertical_lines.jpg";
          case "Cubes Floor Standing":
            return "assets/images/headboard_cubes.jpeg";
          case "Minimalist Floor Standing":
            return "assets/images/headboard_minimalist.jpeg";
          case "Chesterfield Standing":
            return "assets/images/headboard_chesterfield.jpeg";
          case "Straight Circle Winged":
            return "assets/images/headboard_circle_winged.jpeg";
          case "Cubed Small Headboard":
            return "assets/images/headboard_cubed_small.jpeg";
          case "Horizontal Lined Small":
            return "assets/images/headboard_horizontal_lined.jpeg";
          case "Modern Minimalists Small":
            return "assets/images/headboard_modern_minimalist.jpeg";
          default:
            return null;
        }
      case 2:
        return null;
      case 3: // Fabric selection
        switch (selectedFabric) {
          case "Plush":
            return "assets/images/plush.jpeg";
          case "Wool":
            return "assets/images/wool.jpeg";
          case "Naples":
            return "assets/images/naples.jpeg";
          case "Linen":
            return "assets/images/linen.jpeg";
          case "Cricket Velvet":
            return "assets/images/velvet.jpeg";
          case "Chenille":
            return "assets/images/chenielle.jpeg";
          default:
            return null;
        }
      case 4: // Color selection
        return "color_preview";
      default:
        return "assets/images/ottoman.png";
    }
  }

  void nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      // Final step reached - Show the payment screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FinalProductScreen(
            selectedBase: selectedBase!,
            selectedHeadboard: selectedHeadboard!,
            selectedSize: selectedSize!,
            selectedFabric: selectedFabric!,
            selectedColor: selectedColor!,
          ),
        ),
      );
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  Widget buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        steps.length,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentStep
                ? Color.fromARGB(217, 214, 191, 175)
                : Color.fromRGBO(217, 214, 191, 0.77), // Adjusted opacity
          ),
          child: Center(
            child: Text(
              "${index + 1}",
              style: TextStyle(
                color: index == currentStep ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOptionButton(String option) {
    bool isSelected = false;
    switch (currentStep) {
      case 0:
        isSelected = selectedBase == option;
        break;
      case 1:
        isSelected = selectedHeadboard == option;
        break;
      case 2:
        isSelected = selectedSize == option;
        break;
      case 3:
        isSelected = selectedFabric == option;
        break;
      case 4:
        isSelected = selectedColor == option;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2 - 32, // Ensures two options per row
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected
                ? Color.fromARGB(217, 214, 191, 175)
                : Colors.white, // Updated button color
            side: BorderSide(
              color: isSelected
                  ? Color.fromARGB(217, 214, 191, 175)
                  : Colors.grey.shade300,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            setState(() {
              steps[currentStep]["onSelect"](option);
            });
          },
          child: Text(
            option,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.black : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
  Color getColorFromString(String color) {
    switch (color) {
      case "Brown":
        return Colors.brown;
      case "Grey":
        return Colors.grey;
      case "Blue":
        return Colors.blue;
      case "Ivory":
        return Color(0xFFFFF8E1); // Ivory color code
      case "Beige":
        return Color(0xFFF5F5DC); // Beige color code
      case "Pink":
        return Colors.pink;
      case "Duck Egg":
        return Color(0xFFE0F7FA); // Duck Egg color code
      case "White":
        return Colors.white;
      case "Silver":
        return Color(0xFFC0C0C0); // Silver color code
      case "Mink":
        return Color(0xFF6D4C41); // Mink color code
      case "Midnight Blue":
        return Color(0xFF003366); // Midnight Blue color code
      case "Silver(light)":
        return Color(0xFFD3D3D3); // Light Silver color code
      case "Grey(light)":
        return Color(0xFFB0B0B0); // Light Grey color code
      case "Grey(dark)":
        return Color(0xFF505050); // Dark Grey color code
      case "Green":
        return Colors.green;
      case "Turquoise":
        return Color(0xFF40E0D0); // Turquoise color code
      case "Mustard":
        return Color(0xFFFFDB58); // Mustard color code
      case "Steel":
        return Color(0xFF4682B4); // Steel color code
      case "Camel":
        return Color(0x00c19a6b); // Camel color code
      case "Lilac":
        return Color(0xFFB9AEDC); // Lilac color code
      case "Maroon":
        return Color(0xFF800000); // Maroon color code
      case "Black":
        return Colors.black;
      default:
        return Colors.white; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = steps[currentStep];
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Custom Bed Design"),
        backgroundColor: Color.fromARGB(217, 214, 191, 175),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildStepIndicator(),
              const SizedBox(height: 20),
              Text(
                step["title"],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                step["subtitle"],
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                height: 250, // fixed height to prevent infinite growth
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: previewImage == null
                    ? const SizedBox.shrink()
                    : previewImage == "color_preview"
                    ? Container(color: getColorFromString(selectedColor!))
                    : Image.asset(
                  previewImage!,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: step["options"]
                    .map<Widget>((opt) => buildOptionButton(opt))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentStep > 0)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: previousStep,
                      child: const Text(
                        "PREVIOUS",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  if (currentStep > 0) const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(217, 214, 191, 175),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: nextStep,
                    child: Text(
                      currentStep == steps.length - 1 ? "FINISH" : "NEXT",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FinalProductScreen extends StatelessWidget {
  final String selectedBase;
  final String selectedHeadboard;
  final String selectedSize;
  final String selectedFabric;
  final String selectedColor;

  FinalProductScreen({
    super.key,
    required this.selectedBase,
    required this.selectedHeadboard,
    required this.selectedSize,
    required this.selectedFabric,
    required this.selectedColor,
  });

  final Map<String, String> paymentLinks = {
    "PayPal": "https://www.paypal.com",
    "Razorpay": "https://razorpay.com",
    "Stripe": "https://stripe.com",
    "MasterCard": "https://www.mastercard.com",
    "Visa": "https://www.visa.com",
  };

  final Map<String, String> paymentImages = {
    "PayPal": "assets/images/paypal.png", // Replace with your actual image path
    "Razorpay": "assets/images/razorpay.png", // Replace with your actual image path
    "Stripe": "assets/images/stripe.png", // Replace with your actual image path
    "MasterCard": "assets/images/mastercard.png", // Replace with your actual image path
    "Visa": "assets/images/visa.png", // Replace with your actual image path
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text("Final Product Details"),
        backgroundColor: Color.fromARGB(217, 214, 191, 175),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // Space after the back button
            // Row to display the image placeholder on the left, text content on the right
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for the image on the left
                Container(
                  width: 240, // Width for the placeholder
                  height: 240, // Height for the placeholder
                  color: Colors.grey[300], // Grey color as placeholder
                  child: Icon(Icons.image, color: Colors.white), // Icon to represent image
                ),
                const SizedBox(width: 16), // Spacing between image and text
                // Expanded container for the text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bed Details:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text("Price: £250.00", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text("Base: $selectedBase"),
                      Text("Headboard: $selectedHeadboard"),
                      Text("Size: $selectedSize"),
                      Text("Fabric: $selectedFabric"),
                      Text("Color: $selectedColor"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40), // Space before Payment Methods
            // Payment methods display
            Text("Payment Methods:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              spacing: 16, // Horizontal space between buttons
              runSpacing: 16, // Vertical space between rows
              children: paymentLinks.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: InkWell(
                    onTap: () {
                      // Navigate to respective payment link
                      _launchURL(entry.value);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(217, 214, 191, 175), // Light beige color
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Image.asset(
                        paymentImages[entry.key] ?? "",
                        width: 40, // Size of the image inside button
                        height: 40, // Size of the image inside button
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
