import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/service_center_model.dart';
import '../payment/payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final ServiceCenterModel serviceCenter;

  const BookingScreen({
    super.key,
    required this.serviceCenter,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _currentStep = 0;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  String? _selectedPackage;
  final List<String> _selectedAddons = [];

  // Mock Data
  final List<String> _timeSlots = [
    '09:00 AM', '10:00 AM', '11:00 AM', 
    '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM'
  ];

  final List<Map<String, dynamic>> _packages = [
    {'id': 'basic', 'name': 'Basic Wash', 'price': 15.0, 'desc': 'Exterior wash & dry'},
    {'id': 'premium', 'name': 'Premium Wash', 'price': 25.0, 'desc': 'Exterior + Interior vacuum'},
    {'id': 'ultimate', 'name': 'Ultimate Detail', 'price': 50.0, 'desc': 'Full detail + Waxing'},
  ];

  final List<Map<String, dynamic>> _addons = [
    {'id': 'tire', 'name': 'Tire Shine', 'price': 5.0},
    {'id': 'wax', 'name': 'Spray Wax', 'price': 8.0},
    {'id': 'scent', 'name': 'Air Freshener', 'price': 3.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Service'),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: _handleStepContinue,
        onStepCancel: _handleStepCancel,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 3 ? 'Proceed to Pay' : 'Next'),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Time'),
            content: _buildTimeSelection(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.editing,
          ),
          Step(
            title: const Text('Package'),
            content: _buildPackageSelection(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.editing,
          ),
          Step(
            title: const Text('Add-ons'),
            content: _buildAddonSelection(),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.editing,
          ),
          Step(
            title: const Text('Review'),
            content: _buildReview(),
            isActive: _currentStep >= 3,
            state: _currentStep == 3 ? StepState.editing : StepState.indexed,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Date', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        CalendarDatePicker(
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
          onDateChanged: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
        const SizedBox(height: 16),
        const Text('Select Time Slot', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _timeSlots.map((slot) {
            final isSelected = _selectedTimeSlot == slot;
            return ChoiceChip(
              label: Text(slot),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedTimeSlot = selected ? slot : null;
                });
              },
              selectedColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPackageSelection() {
    return Column(
      children: _packages.map((pkg) {
        final isSelected = _selectedPackage == pkg['id'];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: isSelected 
              ? RoundedRectangleBorder(
                  side: BorderSide(color: AppTheme.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(12))
              : null,
          child: ListTile(
            title: Text(pkg['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(pkg['desc']),
            trailing: Text(
              '\$${pkg['price']}',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            selected: isSelected,
            onTap: () {
              setState(() {
                _selectedPackage = pkg['id'];
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddonSelection() {
    return Column(
      children: _addons.map((addon) {
        final isSelected = _selectedAddons.contains(addon['id']);
        return CheckboxListTile(
          title: Text(addon['name']),
          secondary: Text('\$${addon['price']}'),
          value: isSelected,
          activeColor: AppTheme.primaryColor,
          onChanged: (value) {
            setState(() {
              if (value == true) {
                _selectedAddons.add(addon['id']);
              } else {
                _selectedAddons.remove(addon['id']);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildReview() {
    final pkg = _packages.firstWhere((p) => p['id'] == _selectedPackage, orElse: () => _packages[0]);
    final addons = _addons.where((a) => _selectedAddons.contains(a['id'])).toList();
    
    double total = pkg['price'] as double;
    for (var a in addons) {
      total += a['price'] as double;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReviewRow('Service Center', widget.serviceCenter.name),
            _buildReviewRow('Date', DateFormat('MMM dd, yyyy').format(_selectedDate)),
            _buildReviewRow('Time', _selectedTimeSlot ?? 'Not selected'),
            const Divider(),
            _buildReviewRow('Package', pkg['name'], '\$${pkg['price']}'),
            ...addons.map((a) => _buildReviewRow('Add-on', a['name'], '\$${a['price']}')),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  '\$$total',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value, [String? price]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppTheme.greyColor)),
          Row(
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
              if (price != null) ...[
                const SizedBox(width: 8),
                Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _handleStepContinue() {
    if (_currentStep == 0) {
      if (_selectedTimeSlot == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a time slot')),
        );
        return;
      }
    } else if (_currentStep == 1) {
      if (_selectedPackage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a package')),
        );
        return;
      }
    } else if (_currentStep == 3) {
      // Proceed to Payment
      final pkg = _packages.firstWhere((p) => p['id'] == _selectedPackage);
      final addons = _addons.where((a) => _selectedAddons.contains(a['id'])).toList();
      double total = pkg['price'] as double;
      for (var a in addons) {
        total += a['price'] as double;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentScreen(
            amount: total,
            serviceCenterName: widget.serviceCenter.name,
            description: '${pkg['name']} + ${addons.length} Add-ons',
          ),
        ),
      );
      return;
    }

    setState(() {
      _currentStep += 1;
    });
  }

  void _handleStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    } else {
      Navigator.pop(context);
    }
  }
}
