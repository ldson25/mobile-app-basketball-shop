import 'package:flutter/material.dart';
import '../services/address_service.dart';
import '../core/theme/app_colors.dart';

class AddressPicker extends StatefulWidget {
  final Function(Map<String, String>) onAddressChanged;
  const AddressPicker({super.key, required this.onAddressChanged});

  @override
  State<AddressPicker> createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  final AddressService _service = AddressService();
  List<dynamic> _provinces = [];
  List<dynamic> _districts = [];
  List<dynamic> _wards = [];

  String? _selectedProvince, _selectedDistrict, _selectedWard;
  int? _provinceCode, _districtCode;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    final provinces = await _service.getProvinces();
    setState(() => _provinces = provinces);
  }

  Future<void> _onProvinceChanged(int? code) async {
    if (code == null) return;
    setState(() {
      _provinceCode = code;
      _selectedProvince = _provinces.firstWhere(
        (p) => p['code'] == code,
      )['name'];
      _districts = [];
      _wards = [];
      _selectedDistrict = null;
      _selectedWard = null;
    });
    widget.onAddressChanged({
      'city': _selectedProvince!,
      'district': '',
      'ward': '',
    });
    final districts = await _service.getDistricts(code);
    setState(() => _districts = districts);
  }

  Future<void> _onDistrictChanged(int? code) async {
    if (code == null) return;
    setState(() {
      _districtCode = code;
      _selectedDistrict = _districts.firstWhere(
        (d) => d['code'] == code,
      )['name'];
      _wards = [];
      _selectedWard = null;
    });
    widget.onAddressChanged({
      'city': _selectedProvince!,
      'district': _selectedDistrict!,
      'ward': '',
    });
    final wards = await _service.getWards(code);
    setState(() => _wards = wards);
  }

  void _onWardChanged(String? wardName) {
    setState(() => _selectedWard = wardName);
    widget.onAddressChanged({
      'city': _selectedProvince!,
      'district': _selectedDistrict!,
      'ward': _selectedWard!,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDropdown(
          hint: 'Chọn Tỉnh/Thành phố',
          items: _provinces
              .map(
                (p) => DropdownMenuItem<int>(
                  value: p['code'],
                  child: Text(p['name']),
                ),
              )
              .toList(),
          onChanged: _onProvinceChanged,
          value: _provinceCode,
        ),
        const SizedBox(height: 16),
        if (_provinceCode != null)
          _buildDropdown(
            hint: 'Chọn Quận/Huyện',
            items: _districts
                .map(
                  (d) => DropdownMenuItem<int>(
                    value: d['code'],
                    child: Text(d['name']),
                  ),
                )
                .toList(),
            onChanged: _onDistrictChanged,
            value: _districtCode,
          ),
        if (_districtCode != null)
          _buildDropdown(
            hint: 'Chọn Phường/Xã',
            items: _wards
                .map(
                  (w) => DropdownMenuItem<String>(
                    value: w['name'],
                    child: Text(w['name']),
                  ),
                )
                .toList(),
            onChanged: _onWardChanged,
            value: _selectedWard,
          ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
    T? value,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(hint, style: const TextStyle(color: Colors.white70)),
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      dropdownColor: Colors.grey[900],
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.neon),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
