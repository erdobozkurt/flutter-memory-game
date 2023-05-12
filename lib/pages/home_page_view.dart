import 'package:flutter/material.dart';
import 'package:flutter_memory_game/constants/app_colors.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.linkWater,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie_memory.json',
                width: 200, height: 200, fit: BoxFit.fill),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text('Click the cards in order according to their numbers.',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.ebonyClay,
                          ),
                      textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 4.0, bottom: 8.0),
              child: Text('The test will get progressively harder.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.ebonyClay,
                      ),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * .8, 50),
                  backgroundColor: AppColors.lavender,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    top: 16,
                    bottom: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/game');
                },
                child: Text(
                  'Start',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
