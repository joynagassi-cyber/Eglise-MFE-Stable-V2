// lib/features/membres/presentation/screens/member_detail_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/membres/domain/entities/member.dart';
import 'package:lumina/features/membres/presentation/providers/member_detail_provider.dart';
import 'package:lumina/core/presentation/widgets/audit_badge.dart';
import 'package:lumina/core/providers/user_context_provider.dart';
import 'package:lumina/features/vie-spirituelle/data/repositories/jalons_repository.dart';
import 'package:lumina/features/vie-spirituelle/domain/entities/jalon_spirituel.dart';
import 'package:lumina/features/sacraments/presentation/providers/sacrament_providers.dart';
import 'package:lumina/features/sacraments/domain/entities/sacrament.dart';
import 'package:lumina/features/groups/domain/entities/group_membership.dart';
import 'package:lumina/features/groups/presentation/providers/group_providers.dart';
import 'package:intl/intl.dart';

class MemberDetailScreen extends ConsumerStatefulWidget {
  final String memberId;

  const MemberDetailScreen({super.key, required this.memberId});

  @override
  ConsumerState<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends ConsumerState<MemberDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = const [
    Tab(text: 'Général'),
    Tab(text: 'Famille'),
    Tab(text: 'Spirituel'),
    Tab(text: 'Engagement'),
    Tab(text: 'Finances'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        HapticHelper.selection();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memberAsync = ref.watch(memberDetailProvider(widget.memberId));

    return Scaffold(
      body: memberAsync.when(
        data: (member) {
          if (member == null) return _buildErrorState(context);

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                stretch: true,
                backgroundColor: context.colors.brandPrimaryFire,
                leading: IconButton(
                  icon: CircleAvatar(
                    backgroundColor: context.colors.bgCard.withValues(alpha: 0.8),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  onPressed: () => context.pop(),
                ).withTouchTarget(),
                actions: [
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor: context.colors.bgCard.withValues(alpha: 0.8),
                      child: Icon(
                        Icons.edit_rounded,
                        size: 18,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    onPressed: () async {
                      await HapticHelper.light();
                      if (context.mounted) {
                        unawaited(context.push(AppRoutes.brebisModifierWithId(member.id)));
                      }
                    },
                  ).withTouchTarget(),
                  SizedBox(width: 4),
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor: context.colors.bgCard.withValues(alpha: 0.8),
                      child: Icon(
                        Icons.more_horiz_rounded,
                        size: 18,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    onPressed: () async {
                      await HapticHelper.light();
                      if (context.mounted) {
                        _showOptionsMenu(context, member);
                      }
                    },
                  ).withTouchTarget(),
                  SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient Background "Sacré"
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              context.colors.brandPrimaryFire,
                              context.colors.brandPrimaryFire.withValues(alpha: 0.8),
                              context.colors.brandSecondary.withValues(alpha: 0.9),
                            ],
                          ),
                        ),
                      ),

                      // Pattern subtile
                      Positioned(
                        right: -40,
                        top: -40,
                        child: Opacity(
                          opacity: 0.1,
                          child: Icon(
                            Icons.church_rounded,
                            size: 240,
                            color: context.colors.textOnBrand,
                          ),
                        ),
                      ),

                      // Glass Overlay Immersif
                      Positioned.fill(
                        child: GlassCard(
                          blur: 15,
                          borderRadius: 0.0,
                          padding: EdgeInsets.zero,
                          showShine: true,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  context.colors.glassDark.withValues(alpha: 0.2),
                                  Colors.transparent,
                                  context.colors.glassDark.withValues(alpha: 0.4),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Member Info
                      SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Hero(
                              tag: 'avatar_${member.id}',
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: context.colors.textOnBrand.withValues(alpha: 0.5),
                                      width: 2),
                                  shape: BoxShape.circle,
                                  boxShadow: AppSpacing.shadowMd,
                                ),
                                child: CachedAvatarWidget(
                                  imageUrl: member.photoUrl ?? '',
                                  radius: 54,
                                  fallbackText: member.initials,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              member.fullName,
                              style: AppTypography.headlineMedium.copyWith(
                                color: context.colors.textOnBrand,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (member.subtitle.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  member.subtitle,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: context.colors.textOnBrand.withValues(alpha: 0.85),
                                  ),
                                ),
                              ),
                            SizedBox(height: 20),
                            // Quick Status Pills
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _StatusPill(
                                  label: member.status.label.toUpperCase(),
                                  color: context.colors.brandSecondary,
                                ),
                                if (member.isLeader) ...[
                                  SizedBox(width: 8),
                                  _StatusPill(
                                    label: 'LEADER',
                                    color: context.colors.brandSecondary,
                                    isDarkText: true,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: context.colors.brandPrimaryFire,
                    labelColor: context.colors.brandPrimaryFire,
                    unselectedLabelColor: context.colors.textSecondaryLight,
                    indicatorWeight: 3,
                    labelStyle: AppTypography.labelLarge
                        .copyWith(fontWeight: FontWeight.bold),
                    tabs: _tabs,
                  ),
                ),
                pinned: true,
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _GeneralTab(member: member),
                _FamilyTab(member: member),
                _SpiritualTab(member: member),
                _EngagementTab(member: member),
                _ContributionsTab(member: member),
              ],
            ),
          );
        },
        loading: () => const ShimmerDetail(),
        error: (err, stack) => AppErrorWidget(
          message: 'Impossible de charger le profil',
          technicalDetails: err.toString(),
          onRetry: () => ref.invalidate(memberDetailProvider(widget.memberId)),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 60, color: context.colors.errorText),
          SizedBox(height: 16),
          Text('Membre introuvable'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: Text('Retour'),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, Member member) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: context.colors.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.delete_outline,
                  color: context.colors.errorText,
                ),
                title: Text('Supprimer ce membre',
                  style: TextStyle(color: context.colors.errorText),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDarkText;

  const _StatusPill({
    required this.label,
    required this.color,
    this.isDarkText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDarkText ? context.colors.textPrimaryLight : context.colors.textOnBrand,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: context.colors.bgCard,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

// --- Tabs Wrappers ---

class _GeneralTab extends StatelessWidget {
  final Member member;
  const _GeneralTab({required this.member});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (member.lastModifiedByName != null) ...[
          AuditBadge(
            userName: member.lastModifiedByName,
            userRole: member.lastModifiedByRole,
            modifiedAt: member.lastModifiedAt,
          ),
          SizedBox(height: 16),
        ],
        _InfoCard(
          title: 'Contact',
          icon: Icons.contact_phone,
          children: [
            _InfoRow(label: 'Téléphone', value: member.phone),
            _InfoRow(label: 'Email', value: member.email ?? ''),
            _InfoRow(label: 'Adresse', value: member.address),
            _InfoRow(label: 'Ville', value: member.city ?? ''),
            if (member.userId != null) ...[
              Divider(height: 24),
              _MessageAction(member: member),
            ],
          ],
        ),
        SizedBox(height: 16),
        _InfoCard(
          title: 'Personnel',
          icon: Icons.person,
          children: [
            _InfoRow(label: 'Genre', value: member.gender.label),
            _InfoRow(
              label: 'Anniversaire',
              value: member.birthDate != null
                  ? '${member.birthDate!.day}/${member.birthDate!.month}/${member.birthDate!.year}'
                  : '-',
            ),
            _InfoRow(label: 'Profession', value: member.profession),
            _InfoRow(
              label: 'Âge',
              value: member.birthDate != null
                  ? '${DateTime.now().year - member.birthDate!.year} ans'
                  : '-',
            ),
          ],
        ),
      ],
    );
  }
}

class _FamilyTab extends ConsumerWidget {
  final Member member;
  const _FamilyTab({required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyAsync = ref.watch(familyRelationshipsProvider(member.id));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _InfoCard(
          title: 'Situation Familiale',
          icon: Icons.family_restroom_rounded,
          children: [
            _InfoRow(
              label: 'Statut marital',
              value: member.maritalStatus.label,
            ),
            if (member.spouseName != null && member.spouseName!.isNotEmpty)
              _InfoRow(label: 'Conjoint(e)', value: member.spouseName!),
            if (member.numberOfChildren > 0)
              _InfoRow(
                label: 'Enfants',
                value: '${member.numberOfChildren}',
              ),
          ],
        ),
        SizedBox(height: 16),
        familyAsync.when(
          data: (relationships) {
            if (relationships.isEmpty) {
              return _InfoCard(
                title: 'Liens Familiaux',
                icon: Icons.link_rounded,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Aucun lien familial enregistré.',
                      style: TextStyle(color: context.colors.textSecondary),
                    ),
                  ),
                ],
              );
            }
            return _InfoCard(
              title: 'Liens Familiaux (${relationships.length})',
              icon: Icons.people_outline_rounded,
              children: relationships.map((rel) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(Icons.family_restroom_rounded,
                          size: 18, color: context.colors.brandPrimary),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Membre lié (${rel.relatedMemberId.substring(0, 8)}…)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              _familyRelationLabel(rel.relationshipType),
                              style: TextStyle(
                                fontSize: 12,
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
          loading: () => ShimmerBox(height: 80, borderRadius: 16),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  String _familyRelationLabel(String type) {
    switch (type.toLowerCase()) {
      case 'spouse':
        return 'Conjoint(e)';
      case 'parent':
        return 'Parent';
      case 'child':
        return 'Enfant';
      case 'sibling':
        return 'Frère/Sœur';
      default:
        return type;
    }
  }
}

class _SpiritualTab extends ConsumerWidget {
  final Member member;
  const _SpiritualTab({required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jalonsAsync = ref.watch(jalonsProvider);
    final mesJalonsAsync = ref.watch(memberAchievedJalonsProvider(member.id));
    final userContext = ref.watch(userContextNotifierProvider).value;
    final isSuperAdmin = userContext?.isSuperAdmin ?? false;

    final sacramentsAsync = ref.watch(memberSacramentsProvider(member.id));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Sacrements Officiels',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 12),
        sacramentsAsync.when(
          data: (sacraments) {
            if (sacraments.isEmpty) {
              return Text(
                'Aucun sacrement enregistré',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              );
            }
            return Column(
              children: sacraments
                  .map((s) => _SacramentListTile(sacrament: s))
                  .toList(),
            );
          },
          loading: () => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ShimmerBox(height: 60, borderRadius: 12),
          ),
          error: (err, _) => const SizedBox.shrink(),
        ),

        SizedBox(height: 24),
        Divider(),
        SizedBox(height: 12),

        Text(
          'Jalons Spirituels',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 12),
        jalonsAsync.when(
          data: (jalons) {
            if (jalons.isEmpty) {
              return Text('Aucun jalon défini');
            }
            return Column(
              children: jalons.map((jalon) {
                final monJalon = mesJalonsAsync.valueOrNull
                    ?.where((mj) => mj.jalonId == jalon.id)
                    .firstOrNull;
                final isAchieved = monJalon != null;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _SpiritualJalonCard(
                    jalon: jalon,
                    isAchieved: isAchieved,
                    achievedDate: monJalon?.displayDate,
                    canValidate: isSuperAdmin && !isAchieved,
                    onValidate: () =>
                        _showValidateJalonDialog(context, ref, jalon),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ShimmerBox(height: 60, borderRadius: 12),
          ),
          error: (err, stack) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _showValidateJalonDialog(
    BuildContext context,
    WidgetRef ref,
    JalonSpirituel jalon,
  ) {
    showDialog(
      context: context,
      builder: (context) => _ValidateJalonDialog(
        member: member,
        jalon: jalon,
        onValidated: () {
          ref.invalidate(memberAchievedJalonsProvider(member.id));
          ref.invalidate(jalonsStatsProvider);
        },
      ),
    );
  }
}

class _SpiritualJalonCard extends StatelessWidget {
  final JalonSpirituel jalon;
  final bool isAchieved;
  final String? achievedDate;
  final bool canValidate;
  final VoidCallback onValidate;

  const _SpiritualJalonCard({
    required this.jalon,
    required this.isAchieved,
    this.achievedDate,
    required this.canValidate,
    required this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAchieved
              ? context.colors.successText.withValues(alpha: 0.5)
              : context.colors.borderSubtle,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: jalon.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(jalon.iconData, color: jalon.color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jalon.displayTitre,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: context.colors.textPrimary,
                  ),
                ),
                if (isAchieved && achievedDate != null)
                  Text(
                    'Validé le $achievedDate',
                    style: TextStyle(color: context.colors.successText, fontSize: 13),
                  )
                else
                  Text(
                    'Non validé',
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
          if (isAchieved)
            Icon(Icons.check_circle, color: context.colors.successText)
          else if (canValidate)
            ElevatedButton(
              onPressed: onValidate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: const Size(0, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Valider'),
            ).withTouchTarget(),
        ],
      ),
    );
  }
}

class _ValidateJalonDialog extends StatefulWidget {
  final Member member;
  final JalonSpirituel jalon;
  final VoidCallback onValidated;

  const _ValidateJalonDialog({
    required this.member,
    required this.jalon,
    required this.onValidated,
  });

  @override
  State<_ValidateJalonDialog> createState() => _ValidateJalonDialogState();
}

class _ValidateJalonDialogState extends State<_ValidateJalonDialog> {
  DateTime _selectedDate = DateTime.now();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Valider ${widget.jalon.displayTitre}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Pour : ${widget.member.fullName}'),
          SizedBox(height: 16),
          ListTile(
            title: Text('Date de réalisation'),
            subtitle: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
            leading: Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                locale: const Locale('fr', 'FR'),
                helpText: 'Date de réalisation',
                cancelText: 'Annuler',
                confirmText: 'Confirmer',
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
          ),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (Optionnel)',
              hintText: 'Lieu, témoin...',
            ),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text('Annuler'),
        ),
        Consumer(
          builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() => _isLoading = true);
                      try {
                        final repo = ref.read(jalonsRepositoryProvider);
                        await repo.attribuerJalon(
                          membreId: widget.member.id,
                          jalonId: widget.jalon.id,
                          dateRealisation: _selectedDate,
                          notes: _notesController.text,
                        );
                        widget.onValidated();
                        if (context.mounted) Navigator.pop(context);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Une erreur est survenue lors de la validation')),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _isLoading = false);
                      }
                    },
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: LoadingDots(),
                    )
                  : Text('Confirmer'),
            );
          },
        ),
      ],
    );
  }
}

class _EngagementTab extends ConsumerWidget {
  final Member member;
  const _EngagementTab({required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(memberGroupsProvider(member.id));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _InfoCard(
          title: 'Statut dans l\'Église',
          icon: Icons.shield_rounded,
          children: [
            _InfoRow(label: 'Statut', value: member.status.label),
            _InfoRow(label: 'Est baptisé(e)', value: member.isBaptized ? 'Oui' : 'Non'),
            if (member.isBaptized && member.baptismDate != null)
              _InfoRow(
                label: 'Date de baptême',
                value: '${member.baptismDate!.day}/${member.baptismDate!.month}/${member.baptismDate!.year}',
              ),
            _InfoRow(label: 'Rôle principal', value: member.primaryRole.label),
            if (member.isLeader)
              _InfoRow(label: 'Leader', value: 'Oui'),
          ],
        ),
        SizedBox(height: 16),
        groupsAsync.when(
          data: (memberships) {
            if (memberships.isEmpty) {
              return _InfoCard(
                title: 'Groupes & Ministères',
                icon: Icons.groups_rounded,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Ce membre n\'a encore rejoint aucun groupe.',
                      style: TextStyle(color: context.colors.textSecondary),
                    ),
                  ),
                ],
              );
            }
            return _InfoCard(
              title: 'Groupes (${memberships.length})',
              icon: Icons.groups_rounded,
              children: memberships.map((m) {
                final isActive = m.status == MembershipStatus.active;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.colors.brandPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.group_rounded,
                            size: 16, color: context.colors.brandPrimary),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.memberName ?? 'Groupe',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              'Rôle : ${_groupRoleLabel(m.role)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive
                              ? context.colors.successText.withValues(alpha: 0.1)
                              : context.colors.warningText.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isActive ? 'Actif' : 'En attente',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isActive
                                ? context.colors.successText
                                : context.colors.warningText,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
          loading: () => ShimmerBox(height: 80, borderRadius: 16),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  String _groupRoleLabel(GroupRole role) {
    switch (role) {
      case GroupRole.leader:
        return 'Leader';
      case GroupRole.coLeader:
        return 'Co-Leader';
      case GroupRole.member:
        return 'Membre';
    }
  }
}

class _ContributionsTab extends ConsumerWidget {
  final Member member;
  const _ContributionsTab({required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _InfoCard(
          title: 'Aperçu Financier',
          icon: Icons.account_balance_wallet_rounded,
          children: [
            _InfoRow(
              label: 'Contributeur régulier',
              value: 'Données à venir',
            ),
            _InfoRow(
              label: 'Dernière contribution',
              value: '—',
            ),
            _InfoRow(
              label: 'Total annuel estimé',
              value: '—',
            ),
            SizedBox(height: 8),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 16, color: context.colors.textSecondary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Les données de contributions détaillées seront disponibles prochainement.',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.colors.borderSubtle.withValues(alpha: 0.5)),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: context.colors.brandPrimary, size: 20),
              SizedBox(width: 12),
              Text(
                title.toUpperCase(),
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;

  const _InfoRow({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: context.colors.textSecondary),
          ),
          Text(
            value ?? 'Non renseigné',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _MessageAction extends StatelessWidget {
  final Member member;
  const _MessageAction({required this.member});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await HapticHelper.medium();
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(Icons.message_rounded, color: context.colors.brandPrimary, size: 20),
            SizedBox(width: 12),
            Text(
              'Envoyer un message',
              style: TextStyle(
                color: context.colors.brandPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ).withTouchTarget();
  }
}

class _SacramentListTile extends StatelessWidget {
  final Sacrament sacrament;
  const _SacramentListTile({required this.sacrament});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.colors.brandPrimary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.church, color: context.colors.brandPrimary, size: 20),
      ),
      title: Text(
        sacrament.type.label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Le ${DateFormat('dd/MM/yyyy').format(sacrament.date)}',
        style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
      ),
      trailing: Icon(Icons.chevron_right, size: 16),
      onTap: () async {
        await HapticHelper.light();
      },
    );
  }
}

class ShimmerDetail extends StatelessWidget {
  const ShimmerDetail({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: LoadingDots());
  }
}
