import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:marcos_malaga_app/app/core/utils/app_logger.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/banner_model.dart';

class FirestoreBannersDatasource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'banners';
  static const String _seedAsset = 'assets/json/banners.json';

  FirestoreBannersDatasource(this._firestore);

  Future<List<BannerModel>> fetchBanners() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();

      if (snapshot.docs.isEmpty) {
        return await _seedInitialBanners();
      }

      final list = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return BannerModel.fromJson(data);
      }).toList();

      // Sort by index
      list.sort((a, b) => a.index.compareTo(b.index));

      return list;
    } catch (e, st) {
      AppLogger.e('Error fetching banners from Firestore', e, st);
      // Fallback to local asset
      return await _loadFromLocalAsset();
    }
  }

  Future<void> createBanner(BannerModel banner, {int? index}) async {
    final finalIndex = index ?? (banner.index > 0 ? banner.index : ((await _firestore.collection(_collection).count().get()).count ?? 0));
    final data = banner.copyWith(index: finalIndex).toJson();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _firestore.collection(_collection).doc(banner.id).set(data);
  }

  Future<void> updateBanner(BannerModel banner) async {
    final data = banner.toJson();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection(_collection).doc(banner.id).update(data);
  }

  Future<void> deleteBanner(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  Future<void> saveBannersOrder(List<String> bannerIds) async {
    final batch = _firestore.batch();
    for (int i = 0; i < bannerIds.length; i++) {
      final docRef = _firestore.collection(_collection).doc(bannerIds[i]);
      batch.update(docRef, {'index': i});
    }
    await batch.commit();
  }

  Future<List<BannerModel>> _seedInitialBanners() async {
    try {
      final localBanners = await _loadFromLocalAsset();
      final batch = _firestore.batch();
      for (int i = 0; i < localBanners.length; i++) {
        final b = localBanners[i];
        final docRef = _firestore.collection(_collection).doc(b.id);
        final data = b.copyWith(index: i).toJson();
        batch.set(docRef, data);
      }
      await batch.commit();
      return localBanners;
    } catch (e) {
      AppLogger.e('Error seeding initial banners into Firestore', e);
      return await _loadFromLocalAsset();
    }
  }

  Future<List<BannerModel>> _loadFromLocalAsset() async {
    try {
      final jsonString = await rootBundle.loadString(_seedAsset);
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList.map((json) => BannerModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }
}
