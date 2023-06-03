import 'package:flutter/material.dart';

@immutable
class Configuration {
  static const port = '5001';
  // chỉ hoạt động với web, đối với physical device phải dùng ip
  static const String baseUrlWeb = 'localhost:5001'; //web
  static const String baseUrlPhysicalDevice = '192.168.1.3:5001'; //mobile
  static const String baseUrlPhysicalDevice2 = '10.0.2.2:5001'; //mobile
  // để nguyên 3 cái trên, nếu muốn đổi thiết bị thì đổi cái dưới
  static const String baseUrlConnect = baseUrlPhysicalDevice;
  // accountId: 63bbff18fc13ae649300082a - Chris Vater - token fix cứng nếu chẳng may gặp một lỗi nào đó
  static const String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50X2lkIjoiNjNiYmZmMThmYzEzYWU2NDkzMDAwODJhIiwicGhvbmVOdW1iZXIiOiIwMTIzNDU2Nzg5IiwiaWF0IjoxNjc1NTA2NTA2LCJleHAiOjE2NzgwOTg1MDZ9.YRLyFEV1VKKCBP8QwVJ4ZFDz7BJjNUfOK0BK3CvvdHw';
}