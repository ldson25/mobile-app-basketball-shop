import 'dart:convert';
import 'package:http/http.dart' as http;

class AddressService {
  static const String baseUrl = 'https://provinces.open-api.vn/api';

  Future<List<dynamic>> getProvinces() async {
    final response = await http.get(Uri.parse('$baseUrl/p/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  Future<List<dynamic>> getDistricts(int provinceCode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/p/$provinceCode?depth=2'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['districts'] != null) {
        return data['districts'] as List<dynamic>;
      }
    }
    return [];
  }

  Future<List<dynamic>> getWards(int districtCode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/d/$districtCode?depth=2'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['wards'] != null) {
        return data['wards'] as List<dynamic>;
      }
    }
    return [];
  }
}
