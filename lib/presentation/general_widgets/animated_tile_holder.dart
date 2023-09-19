import 'package:flutter/material.dart';

class AnimatedTileHolder extends StatefulWidget {
  const AnimatedTileHolder({
    super.key,
    required this.child,
    required this.onTap,
  });
  final Widget child;
  final ValueChanged<AnimationController> onTap;

  @override
  State<AnimatedTileHolder> createState() => _AnimatedTileHolderState();
}

class _AnimatedTileHolderState extends State<AnimatedTileHolder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..forward();

    _animation = Tween<double>(begin: 0.5, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap.call(_controller),
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}
