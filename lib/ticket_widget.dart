
import 'package:flutter/material.dart';

class TicketWidget extends StatefulWidget {
  const TicketWidget({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    required this.aspectRatio,
    this.padding,
    this.color = Colors.white,
    this.isCornerRounded = false,
  });

  final double width;
  final double height;
  final double aspectRatio;
  final Widget child;
  final Color color;
  final bool isCornerRounded;
  final EdgeInsetsGeometry? padding;


  @override
  _TicketWidgetState createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 30)]),
      child: ClipPath(
        clipper: TicketClipper(widget.aspectRatio),
        child: AnimatedContainer(
          child: widget.child,
          duration: const Duration(seconds: 1),
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: widget.isCornerRounded ? BorderRadius.circular(20.0) : BorderRadius.circular(0.0),
          ),
        ),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  final double aspectRatio;
  TicketClipper(this.aspectRatio);
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(Rect.fromCircle(center: Offset(0.0, size.height / aspectRatio), radius: 20.0));
    path.addOval(Rect.fromCircle(center: Offset(size.width, size.height / aspectRatio), radius: 20.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}