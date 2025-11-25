import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/vehicle_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();
  
  final _vehicleNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();
  
  String _selectedVehicleType = 'Car';
  final List<String> _vehicleTypes = ['Car', 'SUV', 'Truck', 'Van', 'Motorcycle', 'Other'];
  
  bool _isLoading = false;
  String? _editingVehicleId; // Track if we are editing

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingVehicleId == null ? 'Add Vehicle' : 'Edit Vehicle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon
              Icon(
                Icons.directions_car,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              
              const SizedBox(height: 20),
              
              Text(
                _editingVehicleId == null ? 'Add Your Vehicle' : 'Update Your Vehicle',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Vehicle Name
              TextFormField(
                controller: _vehicleNameController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Name *',
                  hintText: 'e.g., My Car',
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Vehicle Number
              TextFormField(
                controller: _vehicleNumberController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Number *',
                  hintText: 'e.g., ABC-1234',
                  prefixIcon: Icon(Icons.pin),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Vehicle Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedVehicleType,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Type *',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _vehicleTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVehicleType = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Brand
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Brand (Optional)',
                  hintText: 'e.g., Toyota',
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Model
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Model (Optional)',
                  hintText: 'e.g., Camry',
                  prefixIcon: Icon(Icons.car_repair),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Color
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color (Optional)',
                  hintText: 'e.g., Black',
                  prefixIcon: Icon(Icons.color_lens),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Add/Update button
              Row(
                children: [
                  if (_editingVehicleId != null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: OutlinedButton(
                          onPressed: _cancelEdit,
                          child: const Text('Cancel'),
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveVehicle,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(_editingVehicleId == null ? 'Add Vehicle' : 'Update Vehicle'),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // My Vehicles List
              _buildMyVehiclesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyVehiclesList() {
    final authProvider = context.watch<AuthProvider>();
    
    if (authProvider.user == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 40),
        const Text(
          'My Vehicles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<VehicleModel>>(
          stream: _firestoreService.getUserVehicles(authProvider.user!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.lightGreyColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'No vehicles added yet',
                    style: TextStyle(color: AppTheme.greyColor),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final vehicle = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor,
                      child: const Icon(
                        Icons.directions_car,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      vehicle.vehicleName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(vehicle.vehicleNumber),
                        Text(
                          '${vehicle.vehicleType}${vehicle.brand != null ? ' - ${vehicle.brand}' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.greyColor,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _startEdit(vehicle),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDeleteVehicle(vehicle),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _startEdit(VehicleModel vehicle) {
    setState(() {
      _editingVehicleId = vehicle.id;
      _vehicleNameController.text = vehicle.vehicleName;
      _vehicleNumberController.text = vehicle.vehicleNumber;
      _selectedVehicleType = _vehicleTypes.contains(vehicle.vehicleType) ? vehicle.vehicleType : 'Other';
      _brandController.text = vehicle.brand ?? '';
      _modelController.text = vehicle.model ?? '';
      _colorController.text = vehicle.color ?? '';
    });
    // Scroll to top
    Scrollable.ensureVisible(context, alignment: 0.0);
  }

  void _cancelEdit() {
    setState(() {
      _editingVehicleId = null;
      _clearForm();
    });
  }

  void _clearForm() {
    _vehicleNameController.clear();
    _vehicleNumberController.clear();
    _brandController.clear();
    _modelController.clear();
    _colorController.clear();
    _selectedVehicleType = 'Car';
  }

  Future<void> _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      if (authProvider.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to manage vehicles')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final vehicle = VehicleModel(
          id: _editingVehicleId ?? '', // ID is ignored for add, used for update
          userId: authProvider.user!.uid,
          vehicleName: _vehicleNameController.text.trim(),
          vehicleNumber: _vehicleNumberController.text.trim().toUpperCase(),
          vehicleType: _selectedVehicleType,
          brand: _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
          model: _modelController.text.trim().isEmpty ? null : _modelController.text.trim(),
          color: _colorController.text.trim().isEmpty ? null : _colorController.text.trim(),
          addedAt: DateTime.now(), // In real app, preserve original addedAt for updates
        );

        if (_editingVehicleId != null) {
          await _firestoreService.updateVehicle(vehicle);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Vehicle updated successfully!'),
                backgroundColor: AppTheme.successColor,
              ),
            );
          }
        } else {
          await _firestoreService.addVehicle(vehicle);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Vehicle added successfully!'),
                backgroundColor: AppTheme.successColor,
              ),
            );
          }
        }

        if (!mounted) return;

        _cancelEdit(); // Clears form and resets state

      } catch (e) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _confirmDeleteVehicle(VehicleModel vehicle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: Text('Are you sure you want to delete ${vehicle.vehicleName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _firestoreService.deleteVehicle(vehicle.id);
        
        if (!mounted) return;
        
        // If we were editing this vehicle, cancel edit
        if (_editingVehicleId == vehicle.id) {
          _cancelEdit();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Vehicle deleted successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _vehicleNameController.dispose();
    _vehicleNumberController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    super.dispose();
  }
}



