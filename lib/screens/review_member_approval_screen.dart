import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'rejection_reason_screen.dart';

class ReviewMemberApprovalScreen extends StatefulWidget {
  const ReviewMemberApprovalScreen({super.key});

  @override
  State<ReviewMemberApprovalScreen> createState() =>
      _ReviewMemberApprovalScreenState();
}

class _ReviewMemberApprovalScreenState
    extends State<ReviewMemberApprovalScreen> {
  bool _approved = false;
  bool _rejected = false;

  void _approve() {
    setState(() {
      _approved = true;
      _rejected = false;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sarah Jenkins has been approved.'),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.maybePop(context);
    });
  }

  void _reject() {
    showRejectionReasonSheet(
      context,
      memberName: 'Sarah Jenkins',
      onConfirmed: () {
        setState(() {
          _rejected = true;
          _approved = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Application rejected and member notified.'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.maybePop(context);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
              decoration: BoxDecoration(
                color: bg,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Review Member Approval',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                ),
                child: Column(
                  children: [
                    // Profile header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary.withOpacity(0.06),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              // Avatar
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary
                                        .withOpacity(0.2),
                                    width: 4,
                                  ),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFD7A49A),
                                      Color(0xFFE4C9B6),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.12),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'SJ',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              // Pending badge
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color(0xFFFBBF24),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: bg,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(Icons.pending,
                                      color: Colors.white, size: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Sarah Jenkins',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on,
                                  color: AppColors.primary, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Lagos Chapter',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Applied: Oct 24, 2023',
                            style: TextStyle(
                                fontSize: 12, color: subColor),
                          ),
                        ],
                      ),
                    ),

                    // Facial scan section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.face_retouching_natural,
                                  color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Facial Scan Verification',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 140,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                        border: Border.all(
                                          color: AppColors.primary
                                              .withOpacity(0.2),
                                          width: 2,
                                        ),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFD7A49A),
                                            Color(0xFFE4C9B6),
                                          ],
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                            Icons
                                                .face_retouching_natural,
                                            color: Colors.white,
                                            size: 48),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text('Live Scan',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: subColor,
                                        )),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 140,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                        border: Border.all(
                                          color: borderColor,
                                          width: 2,
                                        ),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFA4B1BA),
                                            Color(0xFFB8C4B5),
                                          ],
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.badge,
                                            color: Colors.white,
                                            size: 48),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text('ID Photo',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: subColor,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Match badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Color(0xFF059669), size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  '98% MATCH CONFIRMED',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                    color: const Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ID Document section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(color: AppColors.primary.withOpacity(0.05)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.badge,
                                  color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'National ID Document',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Stack(
                            children: [
                              Container(
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF475569),
                                      Color(0xFF1E293B),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.1),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Icon(Icons.article_outlined,
                                          color: Colors.white
                                              .withOpacity(0.2),
                                          size: 80),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(
                                                14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF1E293B)
                                            .withOpacity(0.9)
                                        : Colors.white
                                            .withOpacity(0.9),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.zoom_in,
                                          size: 14, color: subColor),
                                      const SizedBox(width: 4),
                                      Text('View Fullscreen',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: subColor,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('ID NUMBER',
                                        style: TextStyle(
                                          fontSize: 10,
                                          letterSpacing: 0.8,
                                          color: subColor
                                              .withOpacity(0.6),
                                        )),
                                    const SizedBox(height: 4),
                                    Text(
                                      'NG-2849-XXXX',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('EXPIRY DATE',
                                        style: TextStyle(
                                          fontSize: 10,
                                          letterSpacing: 0.8,
                                          color: subColor
                                              .withOpacity(0.6),
                                        )),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Jan 12, 2028',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              onPressed: _approved ? null : _approve,
                              icon: Icon(
                                _approved
                                    ? Icons.check
                                    : Icons.how_to_reg,
                                size: 18,
                              ),
                              label: Text(
                                _approved
                                    ? 'Approved!'
                                    : 'Approve Member',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _approved
                                    ? const Color(0xFF10B981)
                                    : AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor:
                                    AppColors.primary.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: OutlinedButton.icon(
                              onPressed: _rejected ? null : _reject,
                              icon: Icon(
                                _rejected
                                    ? Icons.close
                                    : Icons.flag_outlined,
                                size: 18,
                                color: _rejected
                                    ? Colors.red.shade400
                                    : null,
                              ),
                              label: Text(
                                _rejected
                                    ? 'Flagged'
                                    : 'Reject / Flag Application',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: _rejected
                                      ? Colors.red.shade400
                                      : null,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: _rejected
                                      ? Colors.red.shade300
                                      : borderColor,
                                  width: 2,
                                ),
                                foregroundColor: isDark
                                    ? const Color(0xFFCBD5E1)
                                    : const Color(0xFF475569),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
