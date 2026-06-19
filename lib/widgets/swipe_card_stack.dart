import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/enums.dart';
import '../models/group_model.dart';

/// Lets a parent (the action buttons) trigger a swipe programmatically,
/// the same way a drag gesture would.
class SwipeCardStackController {
  void Function(SwipeDirection direction)? _trigger;

  void _bind(void Function(SwipeDirection direction) trigger) => _trigger = trigger;

  void swipeLeft() => _trigger?.call(SwipeDirection.left);
  void swipeRight() => _trigger?.call(SwipeDirection.right);
}

/// Tinder/Hinge-style draggable card stack: drag to preview, release past
/// the threshold (or call the controller) to fly the top card off-screen,
/// then report the swipe so the caller can update its data.
class SwipeCardStack extends StatefulWidget {
  final List<BeforeGroup> cards;
  final Widget Function(BuildContext context, BeforeGroup group) cardBuilder;
  final void Function(BeforeGroup group, SwipeDirection direction) onSwiped;
  final SwipeCardStackController? controller;

  const SwipeCardStack({
    super.key,
    required this.cards,
    required this.cardBuilder,
    required this.onSwiped,
    this.controller,
  });

  @override
  State<SwipeCardStack> createState() => _SwipeCardStackState();
}

class _SwipeCardStackState extends State<SwipeCardStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Animation<Offset>? _animation;
  Offset _dragOffset = Offset.zero;
  bool _busy = false;
  String? _topId;

  @override
  void initState() {
    super.initState();
    widget.controller?._bind(_programmaticSwipe);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _topId = widget.cards.isNotEmpty ? widget.cards.first.id : null;
  }

  @override
  void didUpdateWidget(covariant SwipeCardStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newTopId = widget.cards.isNotEmpty ? widget.cards.first.id : null;
    if (newTopId != _topId) {
      _topId = newTopId;
      _busy = false;
      _dragOffset = Offset.zero;
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_busy) return;
    setState(() => _dragOffset += details.delta);
  }

  void _onPanEnd(DragEndDetails details) {
    if (_busy) return;
    final width = MediaQuery.of(context).size.width;
    final threshold = width * 0.28;
    if (_dragOffset.dx.abs() > threshold) {
      _flyOut(_dragOffset.dx > 0 ? SwipeDirection.right : SwipeDirection.left);
    } else {
      _snapBack();
    }
  }

  void _programmaticSwipe(SwipeDirection direction) {
    if (_busy || widget.cards.isEmpty) return;
    _flyOut(direction);
  }

  void _flyOut(SwipeDirection direction) {
    if (widget.cards.isEmpty) return;
    _busy = true;
    final card = widget.cards.first;
    final width = MediaQuery.of(context).size.width;
    final target = Offset(
      direction == SwipeDirection.right ? width * 1.4 : -width * 1.4,
      _dragOffset.dy,
    );
    _animation = Tween<Offset>(begin: _dragOffset, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() => setState(() => _dragOffset = _animation!.value));
    _controller.forward(from: 0).whenComplete(() {
      widget.onSwiped(card, direction);
    });
  }

  void _snapBack() {
    _busy = true;
    _animation = Tween<Offset>(begin: _dragOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() => setState(() => _dragOffset = _animation!.value));
    _controller.forward(from: 0).whenComplete(() {
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cards = widget.cards;
    if (cards.isEmpty) return const SizedBox.shrink();
    final visible = cards.take(3).toList();

    return Stack(
      alignment: Alignment.center,
      children: [
        for (var i = visible.length - 1; i >= 0; i--)
          i == 0 ? _buildTopCard(visible[0]) : _buildStaticCard(visible[i], i),
      ],
    );
  }

  Widget _buildStaticCard(BeforeGroup group, int depth) {
    final scale = 1 - depth * 0.04;
    return Transform.translate(
      offset: Offset(0, depth * 12.0),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: 1 - depth * 0.25,
          child: widget.cardBuilder(context, group),
        ),
      ),
    );
  }

  Widget _buildTopCard(BeforeGroup group) {
    final angle = (_dragOffset.dx / 300).clamp(-0.4, 0.4).toDouble();
    final likeOpacity = (_dragOffset.dx / 120).clamp(0.0, 1.0).toDouble();
    final nopeOpacity = (-_dragOffset.dx / 120).clamp(0.0, 1.0).toDouble();

    return GestureDetector(
      key: ValueKey(group.id),
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: angle,
          child: Stack(
            children: [
              widget.cardBuilder(context, group),
              Positioned(
                top: 32,
                left: 24,
                child: Opacity(opacity: likeOpacity, child: _stamp('BIZZ', BizzColors.like)),
              ),
              Positioned(
                top: 32,
                right: 24,
                child: Opacity(opacity: nopeOpacity, child: _stamp('PASS', BizzColors.nope)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stamp(String text, Color color) {
    return Transform.rotate(
      angle: -0.2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
