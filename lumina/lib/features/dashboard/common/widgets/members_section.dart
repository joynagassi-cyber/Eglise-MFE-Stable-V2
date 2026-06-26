import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
class MembersSection extends StatelessWidget {
  final List<dynamic> groupMembers;

  const MembersSection({super.key, required this.groupMembers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: 'Membres du Groupe', icon: Icons.people),
        SizedBox(height: AppSpacing.md),
        if (groupMembers.isEmpty)
          const EmptyState(
            icon: Icons.person_off,
            title: 'Aucun membre',
            subtitle: 'Ce groupe ne contient pas encore de membres assignés.',
          )
        else
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: groupMembers.length,
              itemBuilder: (context, index) {
                final member = groupMembers[index];
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: context.colors.brandPrimary.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(member.initials),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        member.firstName,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
