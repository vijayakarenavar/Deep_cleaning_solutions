// lib/services/enquiry_service.dart

import 'api_client.dart';

class EnquiryService {
  final ApiClient _api = ApiClient();

  // ── Submit Enquiry ────────────────────────────────────────────────
  Future<Map<String, dynamic>> submitEnquiry({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String address,
    required String state,
    required String city,
    required String serviceType,
    double? sqft,
    bool orderInspection   = false,
    String? inspectionDate,
    String? inspectionTime,
  }) async {
    final response = await _api.post(
      '/enquiry',
      data: {
        'first_name':        firstName,
        'last_name':         lastName,
        'email':             email,
        'mobile':            mobile,
        'address':           address,
        'state':             state,
        'city':              city,
        'service_type':      serviceType,
        if (sqft != null) 'sqft': sqft,
        'order_inspection':  orderInspection,
        if (inspectionDate != null) 'inspection_date': inspectionDate,
        if (inspectionTime != null) 'inspection_time': inspectionTime,
      },
    );
    return response.data;
  }

  // ── Get Enquiries ─────────────────────────────────────────────────
  Future<Map<String, dynamic>> getEnquiries({
    String? status,
    int page = 1,
  }) async {
    final response = await _api.get(
      '/enquiry',
      queryParams: {
        if (status != null) 'status': status,
        'page': page,
      },
    );
    return response.data;
  }

  // ── Get Enquiry Detail ────────────────────────────────────────────
  Future<Map<String, dynamic>> getEnquiryDetail(int enquiryId) async {
    final response = await _api.get('/enquiry/$enquiryId');
    return response.data;
  }

  // ── Cancel Enquiry ────────────────────────────────────────────────
  Future<Map<String, dynamic>> cancelEnquiry(int enquiryId) async {
    final response = await _api.put('/enquiry/$enquiryId/cancel');
    return response.data;
  }
}