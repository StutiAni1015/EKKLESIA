import 'dart:convert';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/app_colors.dart';
import '../core/user_session.dart';
import '../data/country_currency_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Step labels
const _steps = ['Country', 'State / Province', 'City / Area'];

class LocationCurrencyScreen extends StatefulWidget {
  final bool isSetup;
  const LocationCurrencyScreen({super.key, this.isSetup = false});

  @override
  State<LocationCurrencyScreen> createState() => _LocationCurrencyScreenState();
}

class _LocationCurrencyScreenState extends State<LocationCurrencyScreen> {
  int _step = 0;

  // ── Step 1 ─────────────────────────────────────────
  List<csc.Country> _countries = [];
  csc.Country? _country;
  CountryInfo? _currency;

  // ── Step 2 ─────────────────────────────────────────
  List<csc.State> _states = [];
  csc.State? _state;
  bool _loadingStates = false;
  bool _noStates = false;       // country has no state data

  // ── Step 3 ─────────────────────────────────────────
  List<csc.City> _cities = [];
  csc.City? _city;
  bool _loadingCities = false;
  bool _noCities = false;

  // ── Search ─────────────────────────────────────────
  final _searchCtrl = TextEditingController();
  String _query = '';

  // ── Validation ─────────────────────────────────────
  String? _errorMsg;
  bool _validating   = false;   // waiting for Nominatim response
  bool _verifyFailed = false;   // Nominatim returned no results
  bool _isVerified   = false;   // Nominatim confirmed the location

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Data loading ────────────────────────────────────

  Future<void> _loadCountries() async {
    final list = await csc.getAllCountries();
    list.sort((a, b) => a.name.compareTo(b.name));
    if (mounted) setState(() => _countries = list);
  }

  Future<void> _loadStates(String countryIso) async {
    setState(() { _loadingStates = true; _states = []; _state = null; _noStates = false; });
    final list = await csc.getStatesOfCountry(countryIso);
    list.sort((a, b) => a.name.compareTo(b.name));
    if (mounted) setState(() {
      _states = list;
      _loadingStates = false;
      _noStates = list.isEmpty;
    });
  }

  Future<void> _loadCities(String countryIso, String stateIso) async {
    setState(() { _loadingCities = true; _cities = []; _city = null; _noCities = false; });
    final list = await csc.getStateCities(countryIso, stateIso);
    list.sort((a, b) => a.name.compareTo(b.name));
    if (mounted) setState(() {
      _cities = list;
      _loadingCities = false;
      _noCities = list.isEmpty;
    });
  }

  // ── Currency lookup ─────────────────────────────────

  CountryInfo? _findCurrency(csc.Country c) {
    try {
      return allCountries.firstWhere(
        (x) => x.country.toLowerCase() == c.name.toLowerCase(),
      );
    } catch (_) {
      // fallback: match by flag emoji
      try {
        return allCountries.firstWhere((x) => x.flag == c.flag);
      } catch (_) {
        return null;
      }
    }
  }

  // ── Navigation ──────────────────────────────────────

  void _nextStep() {
    setState(() { _errorMsg = null; _verifyFailed = false; });
    if (_step == 0) {
      if (_country == null) {
        setState(() => _errorMsg = 'Please select a country to continue.');
        return;
      }
      _searchCtrl.clear();
      _query = '';
      _loadStates(_country!.isoCode);
      setState(() => _step = 1);
    } else if (_step == 1) {
      if (_state == null && !_noStates) {
        setState(() => _errorMsg = 'Please select a state or province.');
        return;
      }
      _searchCtrl.clear();
      _query = '';
      if (_noStates) {
        _saveWithValidation();
        return;
      }
      _loadCities(_country!.isoCode, _state!.isoCode);
      setState(() => _step = 2);
    } else {
      if (_city == null && !_noCities) {
        setState(() => _errorMsg = 'Please select a city or area.');
        return;
      }
      _saveWithValidation();
    }
  }

  void _prevStep() {
    if (_step == 0) { Navigator.maybePop(context); return; }
    _searchCtrl.clear();
    setState(() { _query = ''; _errorMsg = null; _verifyFailed = false; _isVerified = false; _step--; });
  }

  // ── Nominatim geocoding validation ─────────────────

  Future<bool> _validateLocation() async {
    if (_country == null) return false;

    // Build query: most specific available — city + state + country
    final parts = <String>[
      if (_city  != null) _city!.name,
      if (_state != null) _state!.name,
      _country!.name,
    ];
    final q = parts.join(', ');

    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q'      : q,
      'format' : 'json',
      'limit'  : '1',
    });

    try {
      final response = await http.get(uri, headers: {
        'User-Agent'     : 'Ekklesia/1.0 (flutter-app)',
        'Accept-Language': 'en',
      }).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.isNotEmpty;
      }
      return true;   // network issues → don't block the user
    } catch (_) {
      return true;   // timeout / offline → don't block
    }
  }

  Future<void> _saveWithValidation() async {
    if (_country == null) return;
    setState(() { _validating = true; _errorMsg = null; _verifyFailed = false; });

    final verified = await _validateLocation();

    if (!mounted) return;

    if (!verified) {
      setState(() {
        _validating   = false;
        _verifyFailed = true;
        _isVerified   = false;
        _errorMsg =
            'This location could not be found on the map. '
            'Please double-check your selection, or tap "Save Anyway" to proceed.';
      });
      return;
    }

    setState(() { _validating = false; _isVerified = true; });
    _commitSave();
  }

  void _commitSave() {
    if (_country == null) return;
    userCountryNotifier.value        = _country!.name;
    userCountryIsoNotifier.value     = _country!.isoCode;
    userStateNotifier.value          = _state?.name ?? '';
    userStateIsoNotifier.value       = _state?.isoCode ?? '';
    userCityNotifier.value           = _city?.name ?? '';
    if (_currency != null) {
      userCurrencyNotifier.value       = _currency!.currencyCode;
      userCurrencySymbolNotifier.value = _currency!.symbol;
    }
    Navigator.maybePop(context);
  }

  // ── Filtered lists ──────────────────────────────────

  List<csc.Country> get _filteredCountries {
    if (_query.isEmpty) return _countries;
    final q = _query.toLowerCase();
    return _countries.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  List<csc.State> get _filteredStates {
    if (_query.isEmpty) return _states;
    final q = _query.toLowerCase();
    return _states.where((s) => s.name.toLowerCase().contains(q)).toList();
  }

  List<csc.City> get _filteredCities {
    if (_query.isEmpty) return _cities;
    final q = _query.toLowerCase();
    return _cities.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  // ── Build ───────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Header ───────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _step == 0 ? Icons.close : Icons.arrow_back,
                      color: textColor,
                    ),
                    onPressed: _prevStep,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _steps[_step].toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _stepSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: subColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ── Step progress bar ─────────────────────
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(_steps.length, (i) {
                  final done = i <= _step;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: i < _steps.length - 1 ? 6 : 0),
                      height: 4,
                      decoration: BoxDecoration(
                        color: done ? AppColors.primary : borderColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(_steps.length, (i) => Expanded(
                  child: Text(
                    _steps[i],
                    textAlign: i == 0
                        ? TextAlign.left
                        : i == _steps.length - 1
                            ? TextAlign.right
                            : TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: i == _step ? FontWeight.w700 : FontWeight.w400,
                      color: i == _step ? AppColors.primary : subColor,
                    ),
                  ),
                )),
              ),
            ),
            const SizedBox(height: 12),

            // ── Current selection breadcrumb ──────────
            if (_country != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary.withAlpha(40)),
                  ),
                  child: Row(
                    children: [
                      Text(_country!.flag, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        _country!.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      if (_state != null) ...[
                        Text('  ›  ', style: TextStyle(color: subColor, fontSize: 13)),
                        Text(
                          _state!.name,
                          style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w600),
                        ),
                      ],
                      if (_city != null) ...[
                        Text('  ›  ', style: TextStyle(color: subColor, fontSize: 13)),
                        Text(
                          _city!.name,
                          style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w600),
                        ),
                      ],
                      if (_currency != null || _isVerified) ...[
                        const Spacer(),
                        if (_isVerified)
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.green.withAlpha(30),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified_outlined, size: 12, color: Colors.green),
                                SizedBox(width: 3),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_currency != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _currency!.currencyCode,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),

            // ── Search bar ────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v),
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: _searchHint,
                  hintStyle: TextStyle(color: subColor, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: subColor, size: 20),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: subColor, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: cardBg,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
            ),

            // ── Validation error ──────────────────────
            if (_errorMsg != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _errorMsg!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            // ── List ──────────────────────────────────
            Expanded(
              child: _buildList(
                isDark: isDark,
                textColor: textColor,
                subColor: subColor,
                cardBg: cardBg,
                borderColor: borderColor,
              ),
            ),
          ],
        ),
      ),

      // ── Bottom CTA ────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _canProceed
                      ? (_verifyFailed ? _commitSave : _nextStep)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _verifyFailed
                        ? Colors.orange.shade700
                        : AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withAlpha(60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                  child: _validating
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_verifyFailed)
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(Icons.warning_amber_rounded, size: 18),
                              ),
                            Text(
                              _btnLabel,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ),
              ),
              if (_verifyFailed)
                TextButton(
                  onPressed: () => setState(() {
                    _verifyFailed = false;
                    _errorMsg     = null;
                  }),
                  child: const Text(
                    'Change my selection',
                    style: TextStyle(color: AppColors.primary, fontSize: 13),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────

  String get _stepSubtitle => switch (_step) {
        0 => 'Select your country — currency is set automatically',
        1 => 'Select your state or province',
        _ => 'Choose your city or area',
      };

  String get _searchHint => switch (_step) {
        0 => 'Search country…',
        1 => 'Search state or province…',
        _ => 'Search city or area…',
      };

  bool get _canProceed {
    if (_validating) return false;
    return switch (_step) {
      0 => _country != null,
      1 => _state != null || _noStates,
      _ => _city != null || _noCities || _verifyFailed,
    };
  }

  String get _btnLabel {
    if (_validating) return 'Verifying location…';
    if (_verifyFailed) return 'Save Anyway';
    return switch (_step) {
      0 => _country == null ? 'Select a country' : 'Continue  →',
      1 => _state == null && !_noStates
          ? 'Select a state / province'
          : _noStates
              ? 'Verify & Save'
              : 'Continue  →',
      _ => _city == null && !_noCities ? 'Select a city' : 'Verify & Save',
    };
  }

  Widget _buildList({
    required bool isDark,
    required Color textColor,
    required Color subColor,
    required Color cardBg,
    required Color borderColor,
  }) {
    if (_step == 0) {
      if (_countries.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      final items = _filteredCountries;
      if (items.isEmpty) {
        return _emptyState('No country found for "$_query"', subColor);
      }
      return ListView.separated(
        padding: EdgeInsets.fromLTRB(
            16, 0, 16, MediaQuery.of(context).padding.bottom + 80),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final c = items[i];
          final selected = _country?.isoCode == c.isoCode;
          return _ListTile(
            leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
            title: c.name,
            subtitle: _findCurrency(c).let((cur) =>
                cur != null ? '${cur.currencyCode}  •  ${cur.symbol}' : null),
            selected: selected,
            isDark: isDark,
            textColor: textColor,
            subColor: subColor,
            cardBg: cardBg,
            borderColor: borderColor,
            onTap: () {
              final cur = _findCurrency(c);
              setState(() {
                _country = c;
                _currency = cur;
                _errorMsg = null;
              });
            },
          );
        },
      );
    }

    if (_step == 1) {
      if (_loadingStates) return const Center(child: CircularProgressIndicator());
      if (_noStates) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_city_outlined, size: 48, color: subColor),
                const SizedBox(height: 12),
                Text(
                  'No state/province data for ${_country?.name}.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: subColor, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap "Save Location" to continue with country only.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: subColor, fontSize: 13),
                ),
              ],
            ),
          ),
        );
      }
      final items = _filteredStates;
      if (items.isEmpty) {
        return _emptyState('No state found for "$_query"', subColor);
      }
      return ListView.separated(
        padding: EdgeInsets.fromLTRB(
            16, 0, 16, MediaQuery.of(context).padding.bottom + 80),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final s = items[i];
          final selected = _state?.isoCode == s.isoCode;
          return _ListTile(
            leading: const Icon(Icons.map_outlined, size: 22, color: AppColors.primary),
            title: s.name,
            subtitle: s.isoCode,
            selected: selected,
            isDark: isDark,
            textColor: textColor,
            subColor: subColor,
            cardBg: cardBg,
            borderColor: borderColor,
            onTap: () => setState(() { _state = s; _errorMsg = null; }),
          );
        },
      );
    }

    // Step 3 — City
    if (_loadingCities) return const Center(child: CircularProgressIndicator());
    if (_noCities) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_outlined, size: 48, color: subColor),
              const SizedBox(height: 12),
              Text(
                'No city data for ${_state?.name}.',
                textAlign: TextAlign.center,
                style: TextStyle(color: subColor, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap "Save Location" to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(color: subColor, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }
    final items = _filteredCities;
    if (items.isEmpty) {
      return _emptyState('No city found for "$_query"', subColor);
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
          16, 0, 16, MediaQuery.of(context).padding.bottom + 80),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final c = items[i];
        final selected = _city?.name == c.name;
        return _ListTile(
          leading: const Icon(Icons.location_on, size: 22, color: AppColors.primary),
          title: c.name,
          selected: selected,
          isDark: isDark,
          textColor: textColor,
          subColor: subColor,
          cardBg: cardBg,
          borderColor: borderColor,
          onTap: () => setState(() { _city = c; _errorMsg = null; }),
        );
      },
    );
  }

  Widget _emptyState(String msg, Color subColor) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 48, color: subColor),
          const SizedBox(height: 12),
          Text(msg, textAlign: TextAlign.center,
              style: TextStyle(color: subColor, fontSize: 14)),
        ],
      ),
    ),
  );
}

// ── Reusable tile ─────────────────────────────────────────────────────────────
class _ListTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final bool selected;
  final bool isDark;
  final Color textColor, subColor, cardBg, borderColor;
  final VoidCallback onTap;

  const _ListTile({
    required this.leading,
    required this.title,
    this.subtitle,
    required this.selected,
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withAlpha(18) : cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary.withAlpha(120) : borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      )),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Text(subtitle!,
                        style: TextStyle(fontSize: 12, color: subColor)),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}

// ── Extension helper ──────────────────────────────────────────────────────────
extension _Let<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
