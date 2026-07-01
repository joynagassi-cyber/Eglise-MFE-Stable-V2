import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/core/widgets/lumina_progress.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/tasks_provider.dart';
import '../../domain/entities/task.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/extensions/context_extension.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(watchTasksProvider());

    return LuminaPage(
      title: "Journal du Disciple",
      onRefresh: () async => ref.invalidate(watchTasksProvider()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.communicationTasksNew),
        backgroundColor: LuminaDesign.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) return _buildEmptyState(context);

          final completedCount = tasks.where((t) => t.status == TaskStatus.completed).length;
          final completionRate = tasks.isEmpty ? 0.0 : completedCount / tasks.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(LuminaDesign.paddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- PROGRESS OVERVIEW ---
                LuminaCard(
                  color: LuminaDesign.primary.withOpacity(0.05),
                  child: LuminaProgress(
                    progress: completionRate,
                    label: "Maturité par l'action",
                    color: LuminaDesign.primary,
                  ),
                ).animate().fadeIn().slideY(begin: -0.1),

          const SizedBox(height: 24),
                Text("DÉFIS DU JOUR", style: LuminaDesign.labelOf(context)),
    const SizedBox(height: 12),

                // --- TASKS LIST ---
                ...tasks.map((task) => _TaskItem(task: task).animate(delay: 50.ms).fadeIn().slideX(begin: 0.1)),
              ],
            ),
          );
        },
        loading: () => const TasksSkeleton(),
        error: (e, _) => Center(child: Text("Erreur : $e")),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_stories_outlined, size: 64, color: context.colors.textTertiary),
          const SizedBox(height: 16),
          Text("Votre carnet est vide", style: LuminaDesign.h2Of(context)),
          const Text("Commencez par planifier un temps de prière."),
          const SizedBox(height: 24),
          LuminaButton(
            label: "Ajouter une tâche", 
            onPressed: () => context.push(AppRoutes.communicationTasksNew)
          ),
        ],
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final Task task;
  const _TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.completed;

    return LuminaCard(
      onTap: () => context.push(AppRoutes.taskEditWithId(task.id)),
      color: isDone ? Colors.green.withOpacity(0.05) : null,
      child: Row(
        children: [
          // Checkbox Animée
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDone ? Colors.green : context.colors.textTertiary,
                width: 2,
              ),
              color: isDone ? Colors.green : Colors.transparent,
            ),
            child: Icon(
              isDone ? Icons.check : null,
              size: 16,
              color: Colors.white,
    ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title, 
                  style: LuminaDesign.bodyLargeOf(context).copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? context.colors.textTertiary : context.colors.textPrimary,
                  )
                ),
                if (task.description != null) 
                  Text(task.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: LuminaDesign.labelOf(context)),
              ],
            ),
          ),
          if (task.dueDate != null)
            Text(
              "${task.dueDate!.day}/${task.dueDate!.month}", 
              style: LuminaDesign.labelOf(context).copyWith(
                color: _isOverdue(task.dueDate!) ? LuminaDesign.primary : context.colors.textTertiary
              )
            ),
        ],
      ),
    );
  }

  bool _isOverdue(DateTime date) {
    return date.isBefore(DateTime.now()) && task.status != TaskStatus.completed;
  }
}
