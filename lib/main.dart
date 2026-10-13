import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const MotoTravelApp());

const bg = Color(0xFF08111F);
const panel = Color(0xFF142235);
const accent = Color(0xFFFFB52E);
const muted = Color(0xFF9BACBF);

class MotoTravelApp extends StatelessWidget {
  const MotoTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moto Travel',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: WelcomePainter()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.two_wheeler, color: accent, size: 32),
                      SizedBox(width: 10),
                      Text(
                        'MOTO TRAVEL',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'THE ROAD\nIS YOURS.',
                    style: TextStyle(
                      fontSize: 48,
                      height: 0.98,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Find your line. Feel the ride.\nExplore the road ahead.',
                    style: TextStyle(color: muted, height: 1.6),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: bg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GarageScreen(),
                        ),
                      ),
                      child: const Text(
                        'ENTER GARAGE  →',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF193951), bg, Color(0xFF050A12)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect),
    );

    final horizon = size.height * .53;
    final sun = Paint()..color = const Color(0x44FFB52E);
    canvas.drawCircle(Offset(size.width * .76, horizon - 55), 72, sun);

    final mountain = Paint()..color = const Color(0xFF1D3546);
    final path = Path()
      ..moveTo(0, horizon + 40)
      ..lineTo(size.width * .2, horizon - 90)
      ..lineTo(size.width * .38, horizon + 10)
      ..lineTo(size.width * .62, horizon - 125)
      ..lineTo(size.width * .85, horizon + 5)
      ..lineTo(size.width, horizon - 40)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, mountain);

    final road = Path()
      ..moveTo(size.width * .47, horizon)
      ..lineTo(size.width * .53, horizon)
      ..lineTo(size.width * 1.05, size.height)
      ..lineTo(size.width * -.05, size.height)
      ..close();
    canvas.drawPath(road, Paint()..color = const Color(0xFF111B27));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RoadObstacle {
  RoadObstacle({
    required this.lane,
    required this.kind,
    this.progress = 0.02,
  });

  // Lane is -1 (left), 0 (middle), or 1 (right).
  final double lane;
  // 0 = cone, 1 = rock, 2 = road barrier.
  final int kind;
  double progress;
}

class Bike {
  const Bike(this.name, this.subtitle, this.color, this.topSpeed);

  final String name;
  final String subtitle;
  final Color color;
  final int topSpeed;
}

const bikes = [
  Bike('Street Rider', 'BALANCED • EVERYDAY RIDE',
      Color(0xFFFFB52E), 180),
  Bike('Mountain Beast', 'POWER • OPEN ROADS',
      Color(0xFF45D6C5), 220),
  Bike('Night Racer', 'SPORT • HIGH SPEED',
      Color(0xFFFF5B67), 260),
];

class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        title: const Text(
          'YOUR GARAGE',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CHOOSE YOUR RIDE',
                style: TextStyle(color: muted, letterSpacing: 2),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: bikes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final bike = bikes[index];
                    final active = selected == index;
                    return GestureDetector(
                      onTap: () => setState(() => selected = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: panel,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: active ? bike.color : Colors.white10,
                            width: active ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 74,
                                  height: 74,
                                  decoration: BoxDecoration(
                                    color: bike.color.withValues(alpha: .12),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.two_wheeler,
                                    size: 48,
                                    color: bike.color,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bike.name,
                                        style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        bike.subtitle,
                                        style: const TextStyle(
                                          color: muted,
                                          fontSize: 10,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'TOP SPEED  ${bike.topSpeed} km/h',
                                        style: TextStyle(
                                          color: bike.color,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  active
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: bike.color,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: bg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RideScreen(bike: bikes[selected]),
                    ),
                  ),
                  child: const Text(
                    'START RIDE  →',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RideScreen extends StatefulWidget {
  const RideScreen({super.key, required this.bike});

  final Bike bike;

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  Timer? timer;
  bool gas = false;
  bool brake = false;
  bool left = false;
  bool right = false;
  bool paused = false;
  bool crashed = false;

  double speed = 0;
  double distance = 0;
  double roadMotion = 0;
  double position = 0;
  double lean = 0;
  final List<RoadObstacle> obstacles = [];
  final math.Random random = math.Random();
  int ticksUntilObstacle = 30;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (!mounted || paused || crashed) return;

      setState(() {
        if (gas) {
          speed += 1.8;
        } else {
          speed -= 0.45;
        }

        if (brake) speed -= 3.2;
        speed = speed.clamp(0, widget.bike.topSpeed).toDouble();

        if (left) position -= 0.045;
        if (right) position += 0.045;
        position = position.clamp(-1.25, 1.25).toDouble();

        final targetLean = left ? -1.0 : (right ? 1.0 : 0.0);
        lean += (targetLean - lean) * 0.2;

        roadMotion += speed / 600;
        distance += speed / 90000;

        // Spawn obstacles at irregular intervals so every ride feels different.
        ticksUntilObstacle--;
        if (ticksUntilObstacle <= 0) {
          obstacles.add(
            RoadObstacle(
              lane: [-1.0, 0.0, 1.0][random.nextInt(3)],
              kind: random.nextInt(3),
            ),
          );
          ticksUntilObstacle = 38 + random.nextInt(38);
        }

        // Obstacles travel toward the rider. Faster bikes bring them closer faster.
        for (final obstacle in obstacles) {
          obstacle.progress +=
              0.0015 + (speed / widget.bike.topSpeed) * 0.009;
        }
        obstacles.removeWhere((obstacle) => obstacle.progress > 1.08);

        // Check for a collision when an obstacle reaches the rider's position.
        final roadWidthAtRider = MediaQuery.sizeOf(context).width;
        for (final obstacle in obstacles) {
          if (obstacle.progress >= 0.79 && obstacle.progress <= 0.91) {
            final p = obstacle.progress * obstacle.progress;
            final obstacleX = roadWidthAtRider * 0.5 +
                obstacle.lane *
                    roadWidthAtRider *
                    (0.03 + 0.49 * p) *
                    0.48;
            final riderX =
                roadWidthAtRider * (0.5 + position * 0.35);
            if ((obstacleX - riderX).abs() <
                roadWidthAtRider * 0.085) {
              crashed = true;
              speed = 0;
              gas = false;
              break;
            }
          }
        }

        if (position.abs() > 1.03) {
          crashed = true;
          speed = 0;
          gas = false;
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void restart() {
    setState(() {
      speed = 0;
      distance = 0;
      roadMotion = 0;
      position = 0;
      lean = 0;
      obstacles.clear();
      ticksUntilObstacle = 25 + random.nextInt(25);
      gas = false;
      brake = false;
      left = false;
      right = false;
      crashed = false;
      paused = false;
    });
  }

  Widget control({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback down,
    required VoidCallback up,
    bool active = false,
    double size = 68,
  }) {
    return GestureDetector(
      onTapDown: (_) => down(),
      onTapUp: (_) => up(),
      onTapCancel: up,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: .45) : Colors.black54,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? color : Colors.white24,
            width: active ? 2 : 1,
          ),
          boxShadow: active
              ? [BoxShadow(color: color.withValues(alpha: .2), blurRadius: 12)]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: RoadPainter(
                motion: roadMotion,
                position: position,
                lean: lean,
                bikeColor: widget.bike.color,
                speed: speed,
                obstacles: obstacles,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Row(
                    children: [
                      Icon(Icons.two_wheeler, color: widget.bike.color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bike.name.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                            const Text(
                              'FREE RIDE',
                              style: TextStyle(
                                color: muted,
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () => setState(() {
                          paused = !paused;
                          gas = false;
                          brake = false;
                        }),
                        icon: Icon(paused ? Icons.play_arrow : Icons.pause),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'SPEED',
                          value: speed.round().toString(),
                          unit: 'km/h',
                          color: widget.bike.color,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          label: 'DISTANCE',
                          value: distance.toStringAsFixed(2),
                          unit: 'km',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (paused || crashed)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xEE08111F),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: crashed ? Colors.redAccent : accent,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          crashed ? 'RIDE OVER' : 'RIDE PAUSED',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          crashed
                              ? 'You left the road. Try again!'
                              : 'Take a break, rider.',
                          style: const TextStyle(color: muted),
                        ),
                        const SizedBox(height: 14),
                        FilledButton(
                          onPressed: restart,
                          child: const Text('RESTART RIDE'),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          control(
                            label: 'LEFT',
                            icon: Icons.arrow_back_rounded,
                            color: Colors.white,
                            active: left,
                            down: () => setState(() => left = true),
                            up: () => setState(() => left = false),
                          ),
                          const SizedBox(width: 9),
                          control(
                            label: 'RIGHT',
                            icon: Icons.arrow_forward_rounded,
                            color: Colors.white,
                            active: right,
                            down: () => setState(() => right = true),
                            up: () => setState(() => right = false),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          control(
                            label: 'BRAKE',
                            icon: Icons.remove_rounded,
                            color: Colors.redAccent,
                            active: brake,
                            size: 64,
                            down: () => setState(() => brake = true),
                            up: () => setState(() => brake = false),
                          ),
                          const SizedBox(width: 9),
                          control(
                            label: 'GAS',
                            icon: Icons.bolt_rounded,
                            color: accent,
                            active: gas,
                            size: 74,
                            down: () => setState(() => gas = true),
                            up: () => setState(() => gas = false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (crashed)
              const Positioned(
                top: 140,
                left: 0,
                right: 0,
                child: Text(
                  'CRASHED!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xCC08111F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: muted,
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(unit, style: const TextStyle(color: muted, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class RoadPainter extends CustomPainter {
  RoadPainter({
    required this.motion,
    required this.position,
    required this.lean,
    required this.bikeColor,
    required this.speed,
    required this.obstacles,
  });

  final List<RoadObstacle> obstacles;
  final double motion;
  final double position;
  final double lean;
  final Color bikeColor;
  final double speed;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final horizon = h * .39;

    final skyRect = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRect(
      skyRect,
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFF6A9DBA),
            Color(0xFFC5D8D9),
            Color(0xFFEDCDA0),
            Color(0xFF526A50),
          ],
          stops: [0, .22, .38, .40],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(skyRect),
    );

    // Distant mountain ridges.
    _mountains(canvas, size, horizon, 0.15, const Color(0xFF68838A));
    _mountains(canvas, size, horizon + 25, 0.26, const Color(0xFF3D6264));

    // Ground on both sides of the road.
    canvas.drawRect(
      Rect.fromLTWH(0, horizon, w, h - horizon),
      Paint()..color = const Color(0xFF486747),
    );

    // Small fields and roadside terrain.
    final fieldPaint = Paint()..color = const Color(0xFF59764A);
    for (int i = 0; i < 12; i++) {
      final y = horizon + (h - horizon) * i / 12;
      final spread = (y - horizon) * .75;
      canvas.drawLine(
        Offset(0, y),
        Offset(w, y - spread * .05),
        fieldPaint..strokeWidth = 1.0 + i * .15,
      );
    }

    // Road widens toward the player for perspective.
    final road = Path()
      ..moveTo(w * .47, horizon)
      ..lineTo(w * .53, horizon)
      ..lineTo(w * 1.02, h)
      ..lineTo(w * -.02, h)
      ..close();

    canvas.drawPath(
      road,
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFF555C60),
            Color(0xFF343B42),
            Color(0xFF252B32),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, horizon, w, h - horizon)),
    );

    // Road shoulders.
    final shoulder = Paint()
      ..color = const Color(0xFFD0C4A4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawLine(Offset(w * .47, horizon), Offset(-w * .02, h), shoulder);
    canvas.drawLine(Offset(w * .53, horizon), Offset(w * 1.02, h), shoulder);

    // Lane markings scroll toward the rider as speed increases.
    for (int i = 0; i < 14; i++) {
      final t = ((i / 14 + motion % 1) % 1);
      final perspective = t * t;
      final y = horizon + perspective * (h - horizon);
      final centerX = w * .5;
      final halfWidth = w * (.03 + .49 * perspective);
      final dashHeight = 3 + 25 * perspective;
      final dashWidth = 1.5 + 5 * perspective;

      final stripe = Paint()
        ..color = const Color(0xFFE9E4D1).withValues(alpha: .95)
        ..strokeWidth = dashWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(centerX, y),
        Offset(centerX, y + dashHeight),
        stripe,
      );

      // Faint side lines add perspective and depth.
      final side = Paint()
        ..color = Colors.white.withValues(alpha: .25)
        ..strokeWidth = 1 + perspective * 2;

      canvas.drawLine(
        Offset(centerX - halfWidth * .48, y),
        Offset(centerX - halfWidth * .48, y + dashHeight),
        side,
      );
      canvas.drawLine(
        Offset(centerX + halfWidth * .48, y),
        Offset(centerX + halfWidth * .48, y + dashHeight),
        side,
      );
    }

    // Obstacles sit on the road and grow as they approach the rider.
    for (final obstacle in obstacles) {
      final p = obstacle.progress.clamp(0.0, 1.0);
      final perspective = p * p;
      final y = horizon + perspective * (h - horizon);
      final roadHalfWidth =
          w * (0.03 + 0.49 * perspective) * 0.48;
      final x = w * 0.5 + obstacle.lane * roadHalfWidth;
      final scale = 0.22 + perspective * 1.15;
      _drawObstacle(canvas, Offset(x, y), scale, obstacle.kind);
    }

    // Trees and shrubs scale up as they approach the player.
    for (int i = 0; i < 24; i++) {
      final t = ((i / 24 + motion * .25) % 1);
      final p = t * t;
      final y = horizon + p * (h - horizon);
      final scale = .12 + p * 1.05;
      final side = i.isEven ? -1.0 : 1.0;
      final x = w * .5 + side * (w * (.10 + p * .60));
      _tree(canvas, Offset(x, y), scale, i % 3 == 0);
    }

    // Rider's shadow.
    final bikeX = w * (.5 + position * .35);
    final bikeY = h * .78;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(bikeX, bikeY + 37),
        width: 105,
        height: 25,
      ),
      Paint()..color = Colors.black.withValues(alpha: .4),
    );

    _drawBike(canvas, Offset(bikeX, bikeY), bikeColor, lean);

    // Speed-induced subtle motion lines.
    if (speed > 50) {
      final linePaint = Paint()
        ..color = Colors.white.withValues(alpha: .18)
        ..strokeWidth = 1.5;
      for (int i = 0; i < 8; i++) {
        final x = (i / 8) * w;
        canvas.drawLine(
          Offset(x, h * .54),
          Offset(x - 8, h * .62),
          linePaint,
        );
      }
    }

    // Vignette gives the game a more cinematic frame.
    canvas.drawRect(
      skyRect,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: .38),
          ],
          stops: const [0.48, 1],
        ).createShader(skyRect),
    );
  }

  void _drawObstacle(Canvas canvas, Offset base, double scale, int kind) {
    canvas.save();
    canvas.translate(base.dx, base.dy);
    canvas.scale(scale);

    // Ground shadow helps the obstacle feel attached to the road.
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, 2), width: 42, height: 10),
      Paint()..color = Colors.black.withValues(alpha: 0.35),
    );

    if (kind == 0) {
      // Orange traffic cone.
      final cone = Path()
        ..moveTo(0, -34)
        ..lineTo(-13, 0)
        ..lineTo(13, 0)
        ..close();
      canvas.drawPath(cone, Paint()..color = const Color(0xFFFF762F));
      canvas.drawRect(
        const Rect.fromLTWH(-9, -12, 18, 4),
        Paint()..color = Colors.white,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-17, -2, 34, 5),
          const Radius.circular(2),
        ),
        Paint()..color = const Color(0xFFE95425),
      );
    } else if (kind == 1) {
      // Chunky gray rock.
      final rock = Path()
        ..moveTo(-18, -4)
        ..lineTo(-13, -19)
        ..lineTo(-2, -27)
        ..lineTo(12, -20)
        ..lineTo(20, -7)
        ..lineTo(14, 1)
        ..lineTo(-13, 1)
        ..close();
      canvas.drawPath(rock, Paint()..color = const Color(0xFF737D83));
      final highlight = Path()
        ..moveTo(-13, -17)
        ..lineTo(-2, -25)
        ..lineTo(4, -16)
        ..lineTo(-3, -8)
        ..close();
      canvas.drawPath(
        highlight,
        Paint()..color = const Color(0xFFAEB6BA),
      );
    } else {
      // Red-and-white road barrier.
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-25, -23, 50, 23),
          const Radius.circular(3),
        ),
        Paint()..color = const Color(0xFFE8E8E2),
      );
      final stripePaint = Paint()
        ..color = const Color(0xFFD9433D)
        ..strokeWidth = 7;
      for (int i = -1; i <= 1; i++) {
        canvas.drawLine(
          Offset(i * 17 - 5, -22),
          Offset(i * 17 + 5, -1),
          stripePaint,
        );
      }
      canvas.drawRect(
        const Rect.fromLTWH(-28, -3, 56, 5),
        Paint()..color = const Color(0xFF313B42),
      );
    }
    canvas.restore();
  }

  void _mountains(
      Canvas canvas,
      Size size,
      double horizon,
      double heightFactor,
      Color color,
      ) {
    final w = size.width;
    final path = Path()..moveTo(0, horizon + 20);
    for (int i = 0; i <= 12; i++) {
      final x = w * i / 12;
      final variation = math.sin(i * 2.3) * 20 +
          math.cos(i * 1.7) * 12;
      final y = horizon - heightFactor * size.height + variation;
      path.lineTo(x, y);
    }
    path
      ..lineTo(w, horizon + 35)
      ..lineTo(0, horizon + 35)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _tree(Canvas canvas, Offset base, double scale, bool pine) {
    final trunk = Paint()..color = const Color(0xFF42382B);
    final foliage = Paint()
      ..color = pine
          ? const Color(0xFF203F32)
          : const Color(0xFF31583B);

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(base.dx, base.dy - 16 * scale),
        width: 5 * scale,
        height: 32 * scale,
      ),
      trunk,
    );

    if (pine) {
      for (int i = 0; i < 3; i++) {
        final y = base.dy - (24 + i * 13) * scale;
        final path = Path()
          ..moveTo(base.dx, y - 27 * scale)
          ..lineTo(base.dx - 18 * scale, y + 4 * scale)
          ..lineTo(base.dx + 18 * scale, y + 4 * scale)
          ..close();
        canvas.drawPath(path, foliage);
      }
    } else {
      canvas.drawCircle(
        Offset(base.dx, base.dy - 33 * scale),
        16 * scale,
        foliage,
      );
      canvas.drawCircle(
        Offset(base.dx - 10 * scale, base.dy - 25 * scale),
        12 * scale,
        foliage,
      );
      canvas.drawCircle(
        Offset(base.dx + 10 * scale, base.dy - 24 * scale),
        13 * scale,
        foliage,
      );
    }
  }

  void _drawBike(Canvas canvas, Offset center, Color color, double lean) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(lean * .10);

    final black = Paint()..color = const Color(0xFF111820);
    final rubber = Paint()..color = const Color(0xFF090D12);
    final metal = Paint()..color = const Color(0xFFBAC3C8);
    final body = Paint()..color = color;
    final glass = Paint()..color = const Color(0xFF253C4E);

    // Wheels and rims.
    for (final y in [-21.0, 32.0]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, y),
          width: 25,
          height: 43,
        ),
        rubber,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, y),
          width: 11,
          height: 30,
        ),
        Paint()
          ..color = const Color(0xFF85949B)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // Frame and suspension.
    canvas.drawLine(const Offset(0, -20), const Offset(-13, 25), metal..strokeWidth = 4);
    canvas.drawLine(const Offset(0, -20), const Offset(13, 25), metal..strokeWidth = 4);
    canvas.drawLine(const Offset(-13, 25), const Offset(13, 25), black..strokeWidth = 7);

    // Main fairing and fuel tank.
    final fairing = Path()
      ..moveTo(0, -43)
      ..quadraticBezierTo(19, -35, 16, -15)
      ..lineTo(12, 3)
      ..lineTo(6, 14)
      ..lineTo(-8, 12)
      ..lineTo(-16, -8)
      ..quadraticBezierTo(-18, -29, 0, -43)
      ..close();
    canvas.drawPath(fairing, body);

    // Fuel tank highlight.
    final tank = Path()
      ..moveTo(-7, -30)
      ..quadraticBezierTo(0, -36, 8, -29)
      ..lineTo(5, -18)
      ..lineTo(-4, -17)
      ..close();
    canvas.drawPath(tank, Paint()..color = Colors.white.withValues(alpha: .25));

    // Seat and rider silhouette.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-11, -8, 22, 12),
        const Radius.circular(5),
      ),
      black,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, -52), width: 22, height: 25),
      black,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, -54), width: 17, height: 17),
      glass,
    );

    // Handlebars and mirrors.
    canvas.drawLine(const Offset(-16, -28), const Offset(16, -28), metal..strokeWidth = 3);
    canvas.drawCircle(const Offset(-17, -29), 3, black);
    canvas.drawCircle(const Offset(17, -29), 3, black);

    // Headlight.
    final light = Paint()
      ..color = const Color(0xFFFFF2C6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, -39), width: 10, height: 7),
      light,
    );

    // Rear brake light.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-5, 9, 10, 5),
        const Radius.circular(2),
      ),
      Paint()..color = Colors.redAccent,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RoadPainter oldDelegate) => true;
}
