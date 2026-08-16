import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';

class AdminPGEditorScreen extends StatefulWidget {
  final PGModel? pg;
  final AppState appState;

  const AdminPGEditorScreen({
    super.key,
    this.pg,
    required this.appState,
  });

  @override
  State<AdminPGEditorScreen> createState() => _AdminPGEditorScreenState();
}

class _AdminPGEditorScreenState extends State<AdminPGEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _rentController;
  late TextEditingController _depositController;
  late TextEditingController _addressController;
  late TextEditingController _localityController;
  late TextEditingController _contactController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  late TextEditingController _youtubeController;

  late PGType _type;
  late PGAvailability _availability;
  late PGVerificationStatus _verificationStatus;
  late bool _isVerified;
  late List<String> _photos;
  late List<String> _amenities;
  late List<String> _rules;

  static const List<String> _allAmenityOptions = [
    'Wi-Fi',
    'Food',
    'AC',
    'Power backup',
    '24/7 security',
    'Parking',
    'Washing machine',
    'CCTV',
    'Study table',
    'Hot water',
    'Refrigerator',
    'Common room',
    'Attached bathroom',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.pg;

    _nameController = TextEditingController(text: p?.name ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _rentController = TextEditingController(text: p != null ? '${p.monthlyRent.toInt()}' : '8000');
    _depositController = TextEditingController(text: p != null ? '${p.securityDeposit.toInt()}' : '10000');
    _addressController = TextEditingController(text: p?.address ?? '');
    _localityController = TextEditingController(text: p?.locality ?? 'Navrangpura');
    _contactController = TextEditingController(text: p?.contactNumber ?? '+91 98765 43210');
    _latController = TextEditingController(text: p != null ? '${p.latitude}' : '23.0300');
    _lngController = TextEditingController(text: p != null ? '${p.longitude}' : '72.5400');
    _youtubeController = TextEditingController(text: p?.youtubeVideoTitle ?? 'Complete Property Tour');

    _type = p?.type ?? PGType.girls;
    _availability = p?.availability ?? PGAvailability.available;
    _verificationStatus = p?.verificationStatus ?? PGVerificationStatus.published;
    _isVerified = p?.isVerified ?? true;
    _photos = p != null ? List.from(p.photos) : [
      'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=800&q=80',
    ];
    _amenities = p != null ? List.from(p.amenities) : ['Wi-Fi', 'Food', 'AC', '24/7 security'];
    _rules = p != null ? List.from(p.rules) : [
      'No smoking or alcohol strictly prohibited',
      'Entry by 10:00 PM',
      'Minimum stay: 3 months',
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _addressController.dispose();
    _localityController.dispose();
    _contactController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _youtubeController.dispose();
    super.dispose();
  }

  void _savePG() {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.pg?.id ?? 'pg_${DateTime.now().millisecondsSinceEpoch}';
    final savedPG = PGModel(
      id: id,
      name: _nameController.text.trim(),
      type: _type,
      description: _descriptionController.text.trim(),
      monthlyRent: double.tryParse(_rentController.text) ?? 8000,
      securityDeposit: double.tryParse(_depositController.text) ?? 10000,
      sharingType: '2 & 3 Sharing',
      minimumStay: '3 Months',
      foodOption: 'All Meals Included',
      electricityOption: 'Included up to 50 units',
      address: _addressController.text.trim(),
      locality: _localityController.text.trim(),
      city: 'Ahmedabad',
      latitude: double.tryParse(_latController.text) ?? 23.0300,
      longitude: double.tryParse(_lngController.text) ?? 72.5400,
      contactNumber: _contactController.text.trim(),
      isVerified: _isVerified,
      availability: _availability,
      verificationStatus: _verificationStatus,
      photos: _photos,
      amenities: _amenities,
      rules: _rules,
      nearbyLandmarks: widget.pg?.nearbyLandmarks ?? [
        const LandmarkInfo(name: 'Nearby University', distance: '500 m'),
        const LandmarkInfo(name: 'Metro Station', distance: '900 m'),
      ],
      virtualTourScenes: widget.pg?.virtualTourScenes ?? [
        const VirtualTourScene(
          id: 'sc_1',
          title: 'Main Bedroom',
          roomType: 'Bedroom',
          imageUrl: 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=1200&q=80',
          description: 'Spacious air conditioned room with study table.',
        ),
      ],
      youtubeVideoTitle: _youtubeController.text.trim(),
      youtubeVideoId: 'dQw4w9WgXcQ',
      likesCount: widget.pg?.likesCount ?? 0,
      viewsCount: widget.pg?.viewsCount ?? 12,
      contactUnlocksCount: widget.pg?.contactUnlocksCount ?? 0,
      enrollmentsCount: widget.pg?.enrollmentsCount ?? 0,
      createdAt: widget.pg?.createdAt ?? DateTime.now(),
    );

    widget.appState.adminSavePG(savedPG);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PG "${savedPG.name}" saved successfully!'),
        backgroundColor: AppColors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.pg != null;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        title: Text(
          isEditing ? 'Edit PG Listing' : 'Onboard New PG',
          style: AppTypography.titleMedium(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppColors.marigold),
            onPressed: _savePG,
            tooltip: 'Save PG',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            // Basic Information
            Text('Property Details', style: AppTypography.titleMedium()),
            const SizedBox(height: 10),

            _buildLabel('PG Name'),
            TextFormField(
              controller: _nameController,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              decoration: const InputDecoration(hintText: 'e.g. Sunrise Girls PG'),
            ),
            const SizedBox(height: 14),

            _buildLabel('PG Type'),
            Row(
              children: PGType.values.map((t) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(t.label),
                    selected: _type == t,
                    onSelected: (val) {
                      if (val) setState(() => _type = t);
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            _buildLabel('Description'),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              decoration: const InputDecoration(hintText: 'Detailed accommodation summary'),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Monthly Rent (₹)'),
                      TextFormField(
                        controller: _rentController,
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        decoration: const InputDecoration(hintText: '8500'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Security Deposit (₹)'),
                      TextFormField(
                        controller: _depositController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: '10000'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Location
            Text('Location & Coordinates', style: AppTypography.titleMedium()),
            const SizedBox(height: 10),

            _buildLabel('Address'),
            TextFormField(
              controller: _addressController,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              decoration: const InputDecoration(hintText: 'Street address'),
            ),
            const SizedBox(height: 14),

            _buildLabel('Locality / Area'),
            TextFormField(
              controller: _localityController,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              decoration: const InputDecoration(hintText: 'e.g. Navrangpura, Satellite'),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Latitude'),
                      TextFormField(
                        controller: _latController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(hintText: '23.0372'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Longitude'),
                      TextFormField(
                        controller: _lngController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(hintText: '72.5531'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Contact & Status
            Text('Contact & Verification', style: AppTypography.titleMedium()),
            const SizedBox(height: 10),

            _buildLabel('Owner Contact Number (Protected)'),
            TextFormField(
              controller: _contactController,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              decoration: const InputDecoration(hintText: '+91 XXXXX XXXXX'),
            ),
            const SizedBox(height: 14),

            SwitchListTile(
              title: const Text('Verified by PGCity Ops'),
              subtitle: const Text('Displays verified green shield badge to users'),
              value: _isVerified,
              activeTrackColor: AppColors.teal,
              onChanged: (val) => setState(() => _isVerified = val),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 14),

            _buildLabel('Publishing Status (PRD Section 15.2)'),
            Wrap(
              spacing: 8,
              children: PGVerificationStatus.values.map((st) {
                return ChoiceChip(
                  label: Text(st.label),
                  selected: _verificationStatus == st,
                  onSelected: (val) {
                    if (val) setState(() => _verificationStatus = st);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            _buildLabel('Availability Status'),
            Wrap(
              spacing: 8,
              children: PGAvailability.values.map((av) {
                return ChoiceChip(
                  label: Text(av.label),
                  selected: _availability == av,
                  onSelected: (val) {
                    if (val) setState(() => _availability = av);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Amenities Multi-Select
            Text('Amenities', style: AppTypography.titleMedium()),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allAmenityOptions.map((amenity) {
                final isSelected = _amenities.contains(amenity);
                return FilterChip(
                  label: Text(amenity),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _amenities.add(amenity);
                      } else {
                        _amenities.remove(amenity);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePG,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(isEditing ? 'Save Changes' : 'Publish PG to App'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: AppTypography.monoLabel(color: AppColors.inkSoft),
      ),
    );
  }
}
