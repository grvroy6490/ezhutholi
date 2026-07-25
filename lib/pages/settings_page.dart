import 'package:eluthozhi_v3/providers/login_state_provider.dart';
import 'package:eluthozhi_v3/providers/settings_preferences_provider.dart';
import 'package:eluthozhi_v3/providers/theme_provider.dart';
import 'package:eluthozhi_v3/services/support_message_service.dart';
import 'package:eluthozhi_v3/services/remember_me_store.dart';
import 'package:eluthozhi_v3/theme/button_palettes.dart';
import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:eluthozhi_v3/utility/screenUtility.dart';
import 'package:eluthozhi_v3/widgets/accordian_card.dart';
import 'package:eluthozhi_v3/widgets/bottom_nav_bar.dart';
import 'package:eluthozhi_v3/widgets/custom_theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingPage> {
  Future<void> _handleLogout() async {
    final remembered = await RememberMeStore.load();
    if (!mounted) return;
    await Provider.of<LoginStateProvider>(context, listen: false).logOut();
    await ScreenUtils.clearSharedPreferences();
    // Keep remembered email across logout sessions.
    await RememberMeStore.save(
      rememberMe: remembered.rememberMe,
      email: remembered.email,
    );
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginStateProvider>(context);
    final user = loginState.user;
    final displayName = user?.displayName ?? 'Anonymous User';
    final email = user?.email ?? 'No Email';

    return Scaffold(
      backgroundColor: getFigmaColor(context, 'Primary', 'On Main'),
      bottomNavigationBar: BottomNavBar(
        currentRoute: ModalRoute.of(context)?.settings.name ?? '/Settings',
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: getFigmaColor(context, 'Primary', 'On Main'),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    offset: Offset(0, 10),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: getFigmaColor(context, 'Primary', 'Main'),
                      ),
                      width: 70,
                      height: 70,
                      child: Icon(
                        Icons.person,
                        color: getFigmaColor(context, 'Primary', 'On Main'),
                        size: 50,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            displayName,
                            style: AppTypography.titleLarge().copyWith(
                              fontWeight: FontWeight.w400,
                              color: getFigmaColor(context, 'Primary', 'Dark'),
                            ),
                          ),
                          Text(
                            email,
                            style: AppTypography.labelMedium().copyWith(
                              color: getFigmaColor(context, 'Primary', 'Dark'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 'Logout') _handleLogout();
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem<String>(
                          value: 'Logout',
                          child: Text('Logout'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: getFigmaColor(context, 'Surface', 'Surface Dim'),
                  width: double.infinity,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Column(
                      children: [
                        ToggleCard(),
                        SizedBox(height: 10),
                        LanguageCard(),
                        SizedBox(height: 10),
                        FilterStyleCard(),
                        SizedBox(height: 10),
                        TypoStyleCard(),
                        SizedBox(height: 10),
                        FaqsCard(),
                        SizedBox(height: 10),
                        SupportCard(),
                        SizedBox(height: 16),
                        SettingsFooter(),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToggleCard extends StatelessWidget {
  const ToggleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      elevation: 0,
      color: getFigmaColor(context, 'Primary', 'On Main'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enable Dark Mode',
              style: AppTypography.titleMedium().copyWith(
                color: getFigmaColor(context, 'Primary', 'Dark'),
              ),
            ),
            CustomThemeSwitch(
              isDark: themeProvider.isDark,
              onToggle: themeProvider.toggleTheme,
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageCard extends StatelessWidget {
  const LanguageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
          elevation: 0,
          color: getFigmaColor(context, 'Primary', 'On Main'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Language',
                  style: AppTypography.labelSmall().copyWith(
                    color: getFigmaColor(context, 'Primary', 'Dark'),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tamil (தமிழ்)',
                      style: AppTypography.titleMedium().copyWith(
                        color: getFigmaColor(context, 'Primary', 'Dark'),
                      ),
                    ),
                    FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          getFigmaColor(context, 'Secondary', 'Light'),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Change',
                        style: AppTypography.labelMedium().copyWith(
                          color: getFigmaColor(context, 'Secondary', 'Main'),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 1),
        Card(
          elevation: 0,
          margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
          color: getFigmaColor(context, 'Primary', 'On Main'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transcription Language',
                  style: AppTypography.labelSmall().copyWith(
                    color: getFigmaColor(context, 'Primary', 'Dark'),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'English (ஆங்கிலம்)',
                      style: AppTypography.titleMedium().copyWith(
                        color: getFigmaColor(context, 'Primary', 'Dark'),
                      ),
                    ),
                    FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          getFigmaColor(context, 'Secondary', 'Light'),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Change',
                        style: AppTypography.labelMedium().copyWith(
                          color: getFigmaColor(context, 'Secondary', 'Main'),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FilterStyleCard extends StatelessWidget {
  const FilterStyleCard({super.key});

  static const _chipLabels = ['உயிர்', 'ஆய்த', 'மெய்', 'உயிர்மெய்'];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsPreferencesProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;

    return AccordionCard(
      title: 'Filter Style',
      initiallyExpanded: true,
      content: Column(
        children: [
          _FilterOption(
            selected: settings.filterStyle == FilterStyle.colorChips,
            label: 'Style 1 - By Color',
            onTap: () => settings.setFilterStyle(FilterStyle.colorChips),
            preview: _ChipPreview(labels: _chipLabels, isDark: isDark),
          ),
          Divider(
            height: 24,
            color: getFigmaColor(context, 'Schemes', 'Outline Variant'),
          ),
          _FilterOption(
            selected: settings.filterStyle == FilterStyle.colorDots,
            label: 'Style 2 - Color Dots',
            onTap: () => settings.setFilterStyle(FilterStyle.colorDots),
            preview: _DotPreview(isDark: isDark),
          ),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final bool selected;
  final String label;
  final VoidCallback onTap;
  final Widget preview;

  const _FilterOption({
    required this.selected,
    required this.label,
    required this.onTap,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SettingsRadio(selected: selected),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyLarge().copyWith(
                    color: getFigmaColor(context, 'Primary', 'Dark'),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48, right: 4, bottom: 4),
            child: preview,
          ),
        ],
      ),
    );
  }
}

class _ChipPreview extends StatelessWidget {
  final List<String> labels;
  final bool isDark;

  const _ChipPreview({required this.labels, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: getFigmaColor(context, 'Surface', 'Surface Container Low'),
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(labels.length, (index) {
            final palette = ThemedButtonPalettes.getMainPalette(
              themeName: 'default',
              categoryIndex: index,
              isDarkMode: isDark,
            );
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: palette.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  labels[index],
                  style: AppTypography.labelMedium().copyWith(
                    color: palette.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _DotPreview extends StatelessWidget {
  final bool isDark;

  const _DotPreview({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: getFigmaColor(context, 'Surface', 'Surface Container Low'),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(6, (index) {
          final palette = ThemedButtonPalettes.getMainPalette(
            themeName: 'default',
            categoryIndex: index,
            isDarkMode: isDark,
          );
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: palette.backgroundColor,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class TypoStyleCard extends StatelessWidget {
  const TypoStyleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsPreferencesProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;

    return AccordionCard(
      title: 'Typo Style',
      initiallyExpanded: true,
      content: InkWell(
        onTap: () => settings.setTypoStyle(TypoStyle.styleDefault),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _SettingsRadio(
                  selected: settings.typoStyle == TypoStyle.styleDefault,
                ),
                const SizedBox(width: 8),
                Text(
                  'Style 1 - Default',
                  style: AppTypography.bodyLarge().copyWith(
                    color: getFigmaColor(context, 'Primary', 'Dark'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 48, right: 4, bottom: 4),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      getFigmaColor(context, 'Surface', 'Surface Container Low'),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(4, (index) {
                      final palette = ThemedButtonPalettes.getMainPalette(
                        themeName: 'default',
                        categoryIndex: index,
                        isDarkMode: isDark,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: palette.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'அ',
                                style: AppTypography.headlineSmall().copyWith(
                                  color: palette.textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Ak',
                                style: AppTypography.labelMedium().copyWith(
                                  color: palette.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRadio extends StatelessWidget {
  final bool selected;

  const _SettingsRadio({required this.selected});

  @override
  Widget build(BuildContext context) {
    final color = getFigmaColor(context, 'Primary', 'Main');
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            )
          : null,
    );
  }
}

class FaqsCard extends StatelessWidget {
  const FaqsCard({super.key});

  static const _faqs = [
    (
      q: 'How do I hear a letter sound?',
      a: 'On Home, tap any letter tile to play its pronunciation.',
    ),
    (
      q: 'What do the colored category buttons do?',
      a: 'They jump you to that letter group. Change their look in Filter Style.',
    ),
    (
      q: 'How do I switch light and dark mode?',
      a: 'Use Enable Dark Mode at the top of Settings.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AccordionCard(
      title: 'FAQs',
      content: Column(
        children: _faqs.map((faq) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.q,
                  style: AppTypography.titleSmall().copyWith(
                    color: getFigmaColor(context, 'Primary', 'Dark'),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  faq.a,
                  style: AppTypography.bodyLarge().copyWith(
                    color: getFigmaColor(context, 'Secondary', 'Main'),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SupportCard extends StatefulWidget {
  const SupportCard({super.key});

  @override
  State<SupportCard> createState() => _SupportCardState();
}

class _SupportCardState extends State<SupportCard> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _supportService = SupportMessageService();
  bool _submitting = false;

  static const _supportPhone = '7154771976';

  @override
  void initState() {
    super.initState();
    final user = context.read<LoginStateProvider>().user;
    _usernameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _callSupport() async {
    final uri = Uri(scheme: 'tel', path: _supportPhone);
    if (!await launchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the phone dialer')),
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      await _supportService.submitMessage(
        username: _usernameController.text,
        email: _emailController.text,
        message: _messageController.text,
      );
      if (!mounted) return;
      _messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message sent. We will get back to you.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: getFigmaColor(context, 'Surface', 'Surface Container'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: const UnderlineInputBorder(),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: getFigmaColor(context, 'Schemes', 'On Surface'),
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: getFigmaColor(context, 'Primary', 'Main'),
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = getFigmaColor(context, 'Primary', 'Dark');
    final secondary = getFigmaColor(context, 'Secondary', 'Main');

    return AccordionCard(
      title: 'Support',
      initiallyExpanded: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Call us @ 715-477-1976',
            style: AppTypography.titleSmall().copyWith(color: onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            'Mon.-Thurs. 8am-4pm CST\nFri. 8am-noon CST',
            style: AppTypography.bodyLarge().copyWith(color: secondary),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _callSupport,
            style: OutlinedButton.styleFrom(
              foregroundColor: onSurface,
              side: BorderSide(
                color: getFigmaColor(context, 'Schemes', 'Outline'),
              ),
              minimumSize: const Size(120, 42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Call Us'),
          ),
          const SizedBox(height: 20),
          Text(
            'Send us a message',
            style: AppTypography.titleMedium().copyWith(
              color: onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: _fieldDecoration('Username'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _fieldDecoration('Email'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: _fieldDecoration('Your Message'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getFigmaColor(context, 'Primary', 'Dark'),
                    foregroundColor: getFigmaColor(context, 'Primary', 'On Main'),
                    minimumSize: const Size(120, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(_submitting ? 'Sending...' : 'Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  Future<void> _openSite(BuildContext context) async {
    final uri = Uri.parse('https://www.ezhutholi.com');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the website')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(
            'If you want to know more, Please find below link',
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge().copyWith(
              color: getFigmaColor(context, 'Primary', 'Dark'),
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => _openSite(context),
            child: Text(
              'www.Ezhutholi.com',
              style: AppTypography.titleSmall().copyWith(
                color: getFigmaColor(context, 'Primary', 'Main'),
                decoration: TextDecoration.underline,
                decorationColor: getFigmaColor(context, 'Primary', 'Main'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
