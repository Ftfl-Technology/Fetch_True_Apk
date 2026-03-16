import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../model/investment_model.dart';
import '../repository/investment_repository.dart';

class InvestmentRepositoryScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  final String serviceImage;
  const InvestmentRepositoryScreen({super.key, required this.serviceId, required this.serviceImage, required this.serviceName});

  @override
  State<InvestmentRepositoryScreen> createState() => _InvestmentRepositoryScreenState();
}

class _InvestmentRepositoryScreenState extends State<InvestmentRepositoryScreen> {
  final InvestmentRepository _repository = InvestmentRepository();
  int selectedIndex = 0;
  InvestmentItem? activeItem; // global activeItem

  @override
  void initState() {
    super.initState();
    // Fetch the data immediately on screen open
    _loadInvestments();
  }

  void _loadInvestments() async {
    try {
      final response = await _repository.getInvestmentByServiceId(widget.serviceId);
      if (response.data.investment.isNotEmpty) {
        setState(() {
          activeItem = response.data.investment[0]; // first item by default
        });
      }
    } catch (e) {
      // handle error if needed
      debugPrint("Error fetching investments: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'View Breakup', showBackButton: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.serviceImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Final Price",
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          widget.serviceName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Info Chips Row - show immediately using activeItem if available
                Row(
                  children: [
                    _buildInfoChip("Category", widget.serviceName),
                    _buildInfoChip(
                        "Franchise Type", activeItem?.franchiseType ?? "-"),
                    _buildInfoChip("City", activeItem?.city ?? "-"),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // Investment details list
          Expanded(
            child: FutureBuilder<InvestmentResponse>(
              future: _repository.getInvestmentByServiceId(widget.serviceId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.data.investment.isEmpty) {
                  return const Center(
                      child: Text("Data missing or error occurred"));
                }

                final investments = snapshot.data!.data.investment;

                // Update activeItem if null (first load)
                if (activeItem == null) {
                  activeItem = investments[0];
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Franchise Model",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1B5E62)),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Apply Offers",
                                    style: TextStyle(color: CustomColor.appColor),
                                  ),
                                ),
                              ],
                            ),
                            _buildSegmentedControl(investments),
                            const SizedBox(height: 20),

                            // Price Breakup List
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _priceRow(
                                        "Franchise Fee", "₹${activeItem!.franchiseFee}"),
                                    _priceRow("Business Licenses",
                                        "₹${activeItem!.businessLicenses}"),
                                    _priceRow("Insurance", "₹${activeItem!.insurance}"),
                                    _priceRow("Legal & Accounting Fee",
                                        "₹${activeItem!.legalAndAccountingFee}"),
                                    _priceRow(
                                        "Inventory Fee", "₹${activeItem!.inventoryFee}"),
                                    _priceRow(
                                        "Office Setup", "₹${activeItem!.officeSetup}"),
                                    _priceRow(
                                        "Initial Startup & Marketing",
                                        "₹${activeItem!.initialStartupEquipmentAndMarketing}"),
                                    _priceRow(
                                        "Staff & Management Training Expense",
                                        "₹${activeItem!.staffAndManagementTrainingExpense}"),
                                    _priceRow(
                                        "Other Expense", "₹${activeItem!.otherExpense}"),
                              
                                    const Divider(height: 40),
                                  ],
                                ),
                              ),
                            ),

                            // Total Investment Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total\nInvestment",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₹${activeItem!.totalInvestment}",
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6200EE)),
                                    ),
                                    const Text("+GST",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Bottom action buttons
                      Column(
                        spacing: 10,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              side: const BorderSide(color: Colors.green),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: Image.asset(
                              CustomIcon.whatsappIcon,
                              height: 20,
                            ),
                            label: const Text(
                              "Get price details on WhatsApp",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: const Color(0xFF6200EE),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "Secure your spot at just ₹${activeItem!.tokenAmount}/-",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          20.height,
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Info chip
  Widget _buildInfoChip(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500)),
            Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  // Helper: Segmented Control
  Widget _buildSegmentedControl(List<InvestmentItem> investments) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(investments.length, (index) {
        bool isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
              activeItem = investments[index]; // update global activeItem
            });
          },
          child: Column(
            children: [
              Text(
                investments[index].franchiseSize,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF6200EE) : Colors.grey.shade700,
                ),
              ),
              if (isSelected)
                Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 2,
                    width: 40,
                    color: const Color(0xFF6200EE))
            ],
          ),
        );
      }),
    );
  }

  // Helper: Price Row
  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}
