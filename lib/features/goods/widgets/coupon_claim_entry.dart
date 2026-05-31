import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_routes.dart';

/// 领券入口：跳转会员中心领取权益/优惠券。
class CouponClaimEntry extends StatelessWidget {
  const CouponClaimEntry({
    super.key,
    this.style = CouponClaimStyle.inline,
  });

  final CouponClaimStyle style;

  static void openMemberCenter(BuildContext context) {
    context.push(Routes.memberCenter);
  }

  static const _accent = Color(0xFFE85B43);
  static const _chipAccent = Color(0xFFE11D48);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => openMemberCenter(context),
        borderRadius: BorderRadius.circular(
          style == CouponClaimStyle.chip ? 999 : 4,
        ),
        child: style == CouponClaimStyle.chip
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  '领券',
                  style: TextStyle(
                    color: _chipAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '领券',
                    style: TextStyle(
                      color: _accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 1),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: _accent,
                    size: 18,
                  ),
                ],
              ),
      ),
    );
  }
}

enum CouponClaimStyle { inline, chip }
