import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/brand_kit_wizard_cubit.dart';
import '../cubit/brand_kit_wizard_state.dart';

class TargetAudienceStep extends StatefulWidget {
  const TargetAudienceStep({super.key});

  @override
  State<TargetAudienceStep> createState() => _TargetAudienceStepState();
}

class _TargetAudienceStepState extends State<TargetAudienceStep> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandKitWizardCubit, BrandKitWizardState>(
      builder: (context, state) {
        if (_controller.text.isEmpty && state.targetAudience != null) {
          _controller.text = state.targetAudience!;
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Define your target audience',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Who are you trying to reach? Describe your ideal customers, their demographics, interests, and pain points.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),  
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                maxLines: 8,
                onChanged: (value) {
                  context.read<BrandKitWizardCubit>().setTargetAudience(value);
                },
                decoration: const InputDecoration(
                  hintText: 'e.g., Young professionals aged 25-35 who are health-conscious and looking for convenient meal options...',
                  labelText: 'Target Audience',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tips for describing your audience:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildTip(Icons.person, 'Age range and gender'),
              _buildTip(Icons.work, 'Profession and income level'),
              _buildTip(Icons.interests, 'Interests and hobbies'),
              _buildTip(Icons.emoji_emotions, 'Pain points and desires'),
              _buildTip(Icons.location_on, 'Location and lifestyle'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTip(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
