import 'package:flutter/material.dart';

class SkeletonBox extends StatefulWidget {
  const SkeletonBox({super.key, this.width, this.height = 14, this.radius = 8});

  final double? width;
  final double height;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final color = Color.lerp(
          scheme.surfaceContainerHighest,
          scheme.outlineVariant,
          0.15 + 0.35 * _controller.value,
        );
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        );
      },
    );
  }
}

class GroupsSkeleton extends StatelessWidget {
  const GroupsSkeleton({super.key, this.items = 6});

  final int items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Row(
              children: <Widget>[
                SkeletonBox(width: 46, height: 46, radius: 14),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SkeletonBox(width: 120, height: 16),
                      SizedBox(height: 8),
                      SkeletonBox(width: 180, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScheduleSkeleton extends StatelessWidget {
  const ScheduleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: <Widget>[
              for (var i = 0; i < 7; i++)
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: SkeletonBox(width: 42, height: 56, radius: 14),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        for (var day = 0; day < 2; day++) ...<Widget>[
          Row(
            children: const <Widget>[
              SkeletonBox(width: 46, height: 46, radius: 14),
              SizedBox(width: 12),
              SkeletonBox(width: 140, height: 16),
            ],
          ),
          const SizedBox(height: 12),
          for (var lesson = 0; lesson < 2; lesson++)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: SkeletonBox(height: 84, radius: 16),
            ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}
