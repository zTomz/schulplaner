import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mesh/mesh.dart';
import 'package:schulplaner/config/constants/numbers.dart';

extension on OVertex {
  OVertex to(OVertex b, double t) => lerpTo(b, t);
}

extension on Color? {
  Color? to(Color? b, double t) => Color.lerp(this, b, t);
}

class GenerateWithAiButton extends HookWidget {
  final Widget child;
  final Widget icon;
  final Function() onPressed;

  const GenerateWithAiButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 2500),
      lowerBound: 0.0,
      upperBound: 1.0,
      initialValue: 0.0,
      vsync: useSingleTickerProvider(),
    );

    controller
      ..forward()
      ..addListener(() {
        if (controller.value == 1.0) {
          controller.animateTo(0, curve: Curves.easeIn);
        }
        if (controller.value == 0.0) {
          controller.animateTo(1, curve: Curves.easeIn);
        }
      });

    return Material(
      type: MaterialType.button,
      color: Colors.black,
      borderRadius: BorderRadius.circular(360),
      clipBehavior: Clip.hardEdge,
      elevation: 6,
      child: InkWell(
        onTap: onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -25,
              left: -25,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final dt = controller.value;

                  return OMeshGradient(
                    tessellation: 20,
                    size: const Size(500, 500),
                    mesh: OMeshRect(
                      width: 2,
                      height: 3,
                      colorSpace: OMeshColorSpace.lab,
                      fallbackColor: Colors.transparent,
                      vertices: [
                        (0.0, 0.0).v.to((-0.02, -0.39).v, dt),
                        (1.0, 0.0).v.to((1.65, 0.15).v, dt), // Row 1
                        (0.0, 0.0).v.to((0, 0.5).v, dt),
                        (1.0, 0.5).v.to((1.4, 0.98).v, dt), // Row 2
                        (0.0, 1.0).v.to((0, 1).v, dt),
                        (1.0, 1.25).v.to((0, 2).v, dt), // Row 3
                      ],
                      colors: [
                        const Color(0xff88D66C).to(
                          const Color(0xff8FD14F),
                          dt,
                        ),
                        const Color(0xffA1DD70)
                            .to(const Color(0xffBEDC74), dt), // Row 1
                        const Color(0xff1ee38b).to(
                          const Color(0xff88D66C),
                          dt,
                        ),
                        const Color(0xff66ff6d)
                            .to(const Color(0xff9CDBA6), dt), // Row 2
                        const Color(0xff92ff77).to(
                          const Color(0xff41B06E),
                          dt,
                        ),
                        const Color(0xff3f9b2f).to(
                          const Color(0xff9BCF53),
                          dt,
                        ), // Row 3
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.large,
                vertical: Spacing.medium,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconTheme(
                    data: const IconThemeData(color: Colors.white),
                    child: icon,
                  ),
                  const SizedBox(
                    width: Spacing.medium,
                  ),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    child: child,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
