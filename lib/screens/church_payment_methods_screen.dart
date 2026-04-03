import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';

/// Screen for the church treasurer / admin to manage payment accounts.
/// Members can send offerings directly to these accounts.
class ChurchPaymentMethodsScreen extends StatelessWidget {
  const ChurchPaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Payment Accounts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: textColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showAddSheet(context, isDark, subColor,
                        cardBg, borderColor, textColor),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '+ Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),

            Expanded(
              child: ValueListenableBuilder<List<ChurchPaymentMethod>>(
                valueListenable: churchPaymentMethodsNotifier,
                builder: (context, methods, _) {
                  return ListView(
                    padding: EdgeInsets.fromLTRB(
                        16, 20, 16,
                        MediaQuery.of(context).padding.bottom + 32),
                    children: [
                      // Info banner
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.15)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline,
                                color: AppColors.primary, size: 16),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Members will see these accounts when sending '
                                'tithes and offerings. Keep details accurate '
                                'and up-to-date.',
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.5,
                                  color: isDark
                                      ? AppColors.primary.withOpacity(0.9)
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (methods.isEmpty) ...[
                        _EmptyState(
                          isDark: isDark,
                          subColor: subColor,
                          textColor: textColor,
                          onAdd: () => _showAddSheet(context, isDark, subColor,
                              cardBg, borderColor, textColor),
                        ),
                      ] else ...[
                        Text(
                          '${methods.length} Account${methods.length != 1 ? 's' : ''} Added',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: subColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...methods.map((m) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _MethodCard(
                                method: m,
                                isDark: isDark,
                                cardBg: cardBg,
                                borderColor: borderColor,
                                subColor: subColor,
                                textColor: textColor,
                                onSetPrimary: () {
                                  final updated = methods
                                      .map((x) => ChurchPaymentMethod(
                                            id: x.id,
                                            type: x.type,
                                            label: x.label,
                                            detail: x.detail,
                                            isPrimary: x.id == m.id,
                                          ))
                                      .toList();
                                  churchPaymentMethodsNotifier.value = updated;
                                },
                                onDelete: () {
                                  churchPaymentMethodsNotifier.value =
                                      methods.where((x) => x.id != m.id).toList();
                                },
                              ),
                            )),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSheet(
    BuildContext context,
    bool isDark,
    Color subColor,
    Color cardBg,
    Color borderColor,
    Color textColor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddPaymentSheet(
        isDark: isDark,
        cardBg: cardBg,
        borderColor: borderColor,
        subColor: subColor,
        textColor: textColor,
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final Color subColor;
  final Color textColor;
  final VoidCallback onAdd;

  const _EmptyState({
    required this.isDark,
    required this.subColor,
    required this.textColor,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
              child: const Icon(Icons.account_balance,
                  color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'No Payment Accounts Yet',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add UPI, bank, card, Apple Pay or\nPayPal so members can give directly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: subColor, height: 1.6),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Payment Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Payment method card ───────────────────────────────────────────────────────

class _MethodCard extends StatelessWidget {
  final ChurchPaymentMethod method;
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color subColor;
  final Color textColor;
  final VoidCallback onSetPrimary;
  final VoidCallback onDelete;

  const _MethodCard({
    required this.method,
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.subColor,
    required this.textColor,
    required this.onSetPrimary,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: method.isPrimary
              ? AppColors.primary.withOpacity(0.4)
              : borderColor,
          width: method.isPrimary ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Type icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: method.typeColor.withOpacity(0.12),
            ),
            child: Icon(method.typeIcon, color: method.typeColor, size: 22),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      method.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    if (method.isPrimary) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PRIMARY',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  method.detail,
                  style: TextStyle(fontSize: 12, color: subColor),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: method.typeColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    method.typeLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: method.typeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Actions
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: subColor, size: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            onSelected: (v) {
              if (v == 'primary') onSetPrimary();
              if (v == 'copy') {
                Clipboard.setData(ClipboardData(text: method.detail));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${method.typeLabel} details copied!'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
              if (v == 'delete') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text('Remove Account?',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Text(
                        'Remove "${method.label}" from payment accounts?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          onDelete();
                        },
                        child: const Text('Remove',
                            style: TextStyle(color: Color(0xFFEF4444))),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (_) => [
              if (!method.isPrimary)
                const PopupMenuItem(
                  value: 'primary',
                  child: Row(children: [
                    Icon(Icons.star_outline,
                        size: 16, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Set as Primary'),
                  ]),
                ),
              const PopupMenuItem(
                value: 'copy',
                child: Row(children: [
                  Icon(Icons.copy_outlined, size: 16),
                  SizedBox(width: 8),
                  Text('Copy Details'),
                ]),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(children: [
                  Icon(Icons.delete_outline,
                      size: 16, color: Color(0xFFEF4444)),
                  SizedBox(width: 8),
                  Text('Remove',
                      style: TextStyle(color: Color(0xFFEF4444))),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Add payment method bottom sheet ──────────────────────────────────────────

class _AddPaymentSheet extends StatefulWidget {
  final bool isDark;
  final Color cardBg;
  final Color borderColor;
  final Color subColor;
  final Color textColor;

  const _AddPaymentSheet({
    required this.isDark,
    required this.cardBg,
    required this.borderColor,
    required this.subColor,
    required this.textColor,
  });

  @override
  State<_AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<_AddPaymentSheet> {
  PaymentMethodType? _selected;
  final _formKey = GlobalKey<FormState>();

  // UPI
  final _upiCtrl = TextEditingController();

  // Card
  final _cardNumberCtrl = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  final _cardExpiryCtrl = TextEditingController();

  // PayPal
  final _paypalCtrl = TextEditingController();

  // Net Banking
  final _bankNameCtrl = TextEditingController();
  final _accountNumberCtrl = TextEditingController();
  final _ifscCtrl = TextEditingController();
  final _accountHolderCtrl = TextEditingController();

  @override
  void dispose() {
    _upiCtrl.dispose();
    _cardNumberCtrl.dispose();
    _cardNameCtrl.dispose();
    _cardExpiryCtrl.dispose();
    _paypalCtrl.dispose();
    _bankNameCtrl.dispose();
    _accountNumberCtrl.dispose();
    _ifscCtrl.dispose();
    _accountHolderCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_selected == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    String label = '';
    String detail = '';

    switch (_selected!) {
      case PaymentMethodType.upi:
        label = 'UPI';
        detail = _upiCtrl.text.trim();
      case PaymentMethodType.card:
        final num = _cardNumberCtrl.text.replaceAll(' ', '');
        final last4 = num.length >= 4 ? num.substring(num.length - 4) : num;
        label = 'Card •••• $last4';
        detail = _cardNameCtrl.text.trim();
      case PaymentMethodType.applePay:
        label = 'Apple Pay';
        detail = 'Merchant account configured';
      case PaymentMethodType.paypal:
        label = 'PayPal';
        detail = _paypalCtrl.text.trim();
      case PaymentMethodType.netBanking:
        label = _bankNameCtrl.text.trim();
        final acc = _accountNumberCtrl.text.trim();
        detail =
            'Acct •••• ${acc.length >= 4 ? acc.substring(acc.length - 4) : acc}'
            ' · ${_ifscCtrl.text.trim()}';
    }

    final isPrimary = churchPaymentMethodsNotifier.value.isEmpty;
    final id = DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(9999).toString();

    churchPaymentMethodsNotifier.value = [
      ...churchPaymentMethodsNotifier.value,
      ChurchPaymentMethod(
        id: id,
        type: _selected!,
        label: label,
        detail: detail,
        isPrimary: isPrimary,
      ),
    ];

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text('$label added successfully!'),
        ]),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: widget.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              _selected == null ? 'Add Payment Account' : 'Enter Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
            ),
            Text(
              _selected == null
                  ? 'Choose how members can send you money.'
                  : 'Fill in the details for your ${_paymentTypes.firstWhere((t) => t.type == _selected).label} account.',
              style: TextStyle(
                  fontSize: 13, color: widget.subColor, height: 1.5),
            ),
            const SizedBox(height: 20),

            if (_selected == null) ...[
              // Type selector grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
                children: _paymentTypes.map((t) => _TypeTile(
                  type: t,
                  isDark: widget.isDark,
                  borderColor: widget.borderColor,
                  textColor: widget.textColor,
                  onTap: () => setState(() => _selected = t.type),
                )).toList(),
              ),
            ] else ...[
              // Back to type selection
              GestureDetector(
                onTap: () => setState(() => _selected = null),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios_new,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    const Text('Change type',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: _buildForm(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Account',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    switch (_selected!) {
      case PaymentMethodType.upi:
        return Column(children: [
          _field(ctrl: _upiCtrl, label: 'UPI ID',
              hint: 'e.g. church@okaxis',
              validator: (v) => v!.trim().isEmpty
                  ? 'UPI ID is required'
                  : !v.contains('@') ? 'Enter a valid UPI ID (e.g. name@bank)' : null),
        ]);

      case PaymentMethodType.card:
        return Column(children: [
          _field(ctrl: _cardHolderNameCtrl, label: 'Account Holder Name',
              hint: 'Name on card',
              validator: (v) => v!.trim().isEmpty ? 'Required' : null),
          const SizedBox(height: 12),
          _field(ctrl: _cardNumberCtrl, label: 'Card / Account Number',
              hint: '•••• •••• •••• ••••',
              keyboardType: TextInputType.number,
              maxLength: 19,
              inputFormatters: [_CardNumberFormatter()],
              validator: (v) {
                final d = v!.replaceAll(' ', '');
                if (d.isEmpty) return 'Card number is required';
                if (d.length < 13) return 'Enter a valid card number';
                return null;
              }),
          const SizedBox(height: 12),
          _field(ctrl: _cardExpiryCtrl, label: 'Expiry (MM/YY)',
              hint: '12/28',
              keyboardType: TextInputType.number,
              maxLength: 5,
              inputFormatters: [_ExpiryFormatter()],
              validator: (v) =>
                  v!.trim().length < 5 ? 'Enter valid expiry' : null),
        ]);

      case PaymentMethodType.applePay:
        return Column(children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.phone_iphone,
                    color: Color(0xFF1C1C1E), size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Apple Pay',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.textColor)),
                      Text(
                          'Members on iOS can pay directly via Apple Pay. '
                          'Your merchant account will be configured by your App Clip.',
                          style: TextStyle(
                              fontSize: 12,
                              color: widget.subColor,
                              height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _field(
              ctrl: _paypalCtrl,
              label: 'Apple Pay Merchant Email (optional)',
              hint: 'merchant@church.com',
              keyboardType: TextInputType.emailAddress,
              validator: (_) => null),
        ]);

      case PaymentMethodType.paypal:
        return Column(children: [
          _field(
              ctrl: _paypalCtrl,
              label: 'PayPal Email / Merchant ID',
              hint: 'giving@church.com',
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v!.trim().isEmpty ? 'PayPal email is required' : null),
        ]);

      case PaymentMethodType.netBanking:
        return Column(children: [
          _field(ctrl: _bankNameCtrl, label: 'Bank Name',
              hint: 'e.g. Chase, Barclays, GTBank',
              validator: (v) =>
                  v!.trim().isEmpty ? 'Bank name is required' : null),
          const SizedBox(height: 12),
          _field(ctrl: _accountHolderCtrl, label: 'Account Holder Name',
              hint: 'Grace Community Church',
              validator: (v) =>
                  v!.trim().isEmpty ? 'Account holder name is required' : null),
          const SizedBox(height: 12),
          _field(ctrl: _accountNumberCtrl, label: 'Account Number',
              hint: '0123456789',
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v!.trim().isEmpty ? 'Account number is required' : null),
          const SizedBox(height: 12),
          _field(ctrl: _ifscCtrl, label: 'IFSC / Sort Code / Routing Number',
              hint: 'IFSC / SORT / ABA routing code',
              validator: (v) =>
                  v!.trim().isEmpty ? 'Routing code is required' : null),
        ]);
    }
  }

  // Helper: card name ctrl alias
  TextEditingController get _cardHolderNameCtrl => _cardNameCtrl;

  Widget _field({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: widget.textColor,
            )),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          style: TextStyle(fontSize: 14, color: widget.textColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                color: widget.subColor.withOpacity(0.5), fontSize: 13),
            counterText: '',
            filled: true,
            fillColor: widget.isDark
                ? const Color(0xFF0F172A)
                : const Color(0xFFF8FAFC),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}

// ── Type tile ─────────────────────────────────────────────────────────────────

const _paymentTypes = [
  _PayType(PaymentMethodType.upi, 'UPI',
      Icons.qr_code_2, Color(0xFF8B5CF6)),
  _PayType(PaymentMethodType.card, 'Credit / Debit Card',
      Icons.credit_card, Color(0xFF2563EB)),
  _PayType(PaymentMethodType.applePay, 'Apple Pay',
      Icons.phone_iphone, Color(0xFF1C1C1E)),
  _PayType(PaymentMethodType.paypal, 'PayPal',
      Icons.account_balance_wallet, Color(0xFF003087)),
  _PayType(PaymentMethodType.netBanking, 'Net Banking',
      Icons.account_balance, Color(0xFF059669)),
];

class _PayType {
  final PaymentMethodType type;
  final String label;
  final IconData icon;
  final Color color;
  const _PayType(this.type, this.label, this.icon, this.color);
}

class _TypeTile extends StatelessWidget {
  final _PayType type;
  final bool isDark;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _TypeTile({
    required this.type,
    required this.isDark,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(type.icon, color: type.color, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                type.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Input formatters ──────────────────────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 16; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final str = buffer.toString();
    return newValue.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 2) return newValue.copyWith(text: digits);
    final str = '${digits.substring(0, 2)}/${digits.substring(2, min(digits.length, 4))}';
    return newValue.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}
