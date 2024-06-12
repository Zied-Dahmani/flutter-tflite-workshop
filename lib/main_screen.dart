import 'package:flutter/material.dart';
import 'package:ml_workshop/main_controller.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => MainController(),
      child: Scaffold(
        body: Consumer<MainController>(
          builder: (context, controller, child) {
            return controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.image == null
                    ? Center(child: Text('Pick an image!', style: theme.textTheme.bodyLarge))
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height / 2,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: Image.memory(
                                controller.displayedImage!,
                              ),
                            ),
                            if (controller.category != null) ...[
                              Text(
                                controller.category!.label,
                                style: theme.textTheme.headlineSmall,
                              ),
                              Text(
                                'Confidence: ${controller.category!.score.toStringAsFixed(3)}',
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                          ],
                        ),
                      );
          },
        ),
        floatingActionButton: Consumer<MainController>(
          builder: (context, controller, child) {
            return FloatingActionButton(
              onPressed: controller.pickImage,
              tooltip: 'Pick Image',
              child: const Icon(Icons.add_a_photo),
            );
          },
        ),
      ),
    );
  }
}