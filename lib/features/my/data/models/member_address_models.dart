class MemberAddress {
  const MemberAddress({
    this.id,
    this.name,
    this.mobile,
    this.areaId,
    this.areaName,
    this.detailAddress,
    this.defaultStatus = false,
  });

  final int? id;
  final String? name;
  final String? mobile;
  final int? areaId;
  final String? areaName;
  final String? detailAddress;
  final bool defaultStatus;

  String get fullAddress {
    final area = areaName?.trim() ?? '';
    final detail = detailAddress?.trim() ?? '';
    if (area.isEmpty) return detail;
    if (detail.isEmpty) return area;
    return '$area $detail';
  }

  factory MemberAddress.fromJson(Map<String, dynamic> json) {
    return MemberAddress(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
      areaId: (json['areaId'] as num?)?.toInt(),
      areaName: json['areaName'] as String?,
      detailAddress: json['detailAddress'] as String?,
      defaultStatus: json['defaultStatus'] == true,
    );
  }
}

class MemberAddressSaveReq {
  const MemberAddressSaveReq({
    this.id,
    required this.name,
    required this.mobile,
    required this.areaId,
    required this.detailAddress,
    required this.defaultStatus,
  });

  final int? id;
  final String name;
  final String mobile;
  final int areaId;
  final String detailAddress;
  final bool defaultStatus;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'mobile': mobile,
      'areaId': areaId,
      'detailAddress': detailAddress,
      'defaultStatus': defaultStatus,
    };
  }
}
