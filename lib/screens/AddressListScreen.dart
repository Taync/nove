import 'package:flutter/material.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  List<Map<String, String>> _addresses = [];

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _labelController = TextEditingController();
  String _billingType = 'individual';

  void _showAddAddressModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add New Address",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Billing Type",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'individual',
                        groupValue: _billingType,
                        onChanged:
                            (value) => setState(() => _billingType = value!),
                      ),
                      Text('Individual'),
                      Radio<String>(
                        value: 'corporate',
                        groupValue: _billingType,
                        onChanged:
                            (value) => setState(() => _billingType = value!),
                      ),
                      Text('Corporate'),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildTextField(_fullNameController, 'Full Name'),
                  SizedBox(height: 12),
                  _buildTextField(_phoneController, 'Phone Number'),
                  SizedBox(height: 12),
                  _buildTextField(_addressController, 'Full Address'),
                  SizedBox(height: 12),
                  _buildTextField(_cityController, 'City'),
                  SizedBox(height: 12),
                  _buildTextField(_districtController, 'District'),
                  SizedBox(height: 12),
                  _buildTextField(_neighborhoodController, 'Neighborhood'),
                  SizedBox(height: 12),
                  _buildTextField(
                    _labelController,
                    'Address Label (e.g., Home, Office)',
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_labelController.text.isNotEmpty &&
                          _addressController.text.isNotEmpty) {
                        setState(() {
                          _addresses.add({
                            'label': _labelController.text,
                            'fullName': _fullNameController.text,
                            'phone': _phoneController.text,
                            'address': _addressController.text,
                            'city': _cityController.text,
                            'district': _districtController.text,
                            'neighborhood': _neighborhoodController.text,
                            'billingType': _billingType,
                          });

                          _fullNameController.clear();
                          _phoneController.clear();
                          _addressController.clear();
                          _cityController.clear();
                          _districtController.clear();
                          _neighborhoodController.clear();
                          _labelController.clear();
                          _billingType = 'individual';
                        });

                        Navigator.of(context).pop(); // Kapat modal
                      }
                    },
                    icon: Icon(Icons.save),
                    label: Text("Save Address"),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address Information"),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: _showAddAddressModal),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            _addresses.isEmpty
                ? Center(child: Text("No addresses added yet."))
                : ListView.builder(
                  itemCount: _addresses.length,
                  itemBuilder: (_, index) {
                    final address = _addresses[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(address['label'] ?? ''),
                        subtitle: Text(
                          "${address['city']}, ${address['district']}",
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _addresses.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
