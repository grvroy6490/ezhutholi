import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eluthozhi_v3/providers/theme_provider.dart';
import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:eluthozhi_v3/widgets/accordian_card.dart';
import 'package:eluthozhi_v3/widgets/custom_theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingPage> {
  bool isDarkModeEnabled = false; // Initialize the toggle switch state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getFigmaColor(context, 'Primary', 'On Main'),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: getFigmaColor(context, 'Primary', 'On Main'),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    offset: Offset(0, 10), // Only bottom
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
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
                            'Syed Shahab',
                            style: AppTypography.titleLarge().copyWith(
                              fontWeight: FontWeight.w400,
                              color: getFigmaColor(context, 'Primary', 'Dark'),
                            ),
                          ),
                          Text(
                            'Email address',
                            style: AppTypography.labelMedium().copyWith(
                              color: getFigmaColor(context, 'Primary', 'Dark'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert),
                      onSelected: (String value) {
                        // Handle the selected value
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'Option 1',
                            child: Text('Option 1'),
                          ),
                          PopupMenuItem<String>(
                            value: 'Option 2',
                            child: Text('Option 2'),
                          ),
                        ];
                      },
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Column(
                      children: [
                        ToggleCard(),
                        SizedBox(height: 10),
                        LanguageCard(),
                        SizedBox(height: 10),
                        FilterCard(),
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

// TOGGLE THEME MODE CARD
class ToggleCard extends StatelessWidget {
  const ToggleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // debugPrint('Dark mode enabled: ${getFigmaColor(context, 'Text', 'Primary')}');
    return Card(
      elevation: 0,
      color: getFigmaColor(context, 'Primary', 'On Main'),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enable Dark Mode',
              style: AppTypography.titleMedium().copyWith(
                color: getFigmaColor(context, 'Primary', 'Dark'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: getFigmaColor(context, 'Surface', 'Surface Container'),
                border: Border.all(
                  color: getFigmaColor(
                    context,
                    'Background',
                    'Light Border',
                  ), // Changed to a contrasting color
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Light',
                    style: AppTypography.labelSmall().copyWith(
                      color:
                          themeProvider.isDark
                              ? getFigmaColor(context, 'Text', 'Disabled')
                              : getFigmaColor(context, 'Text', 'Primary'),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10),
                  CustomThemeSwitch(
                    isDark: themeProvider.isDark,
                    onToggle: () {
                      themeProvider.toggleTheme();
                    },
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Dark',
                    style: AppTypography.labelSmall().copyWith(
                      color:
                          themeProvider.isDark
                              ? getFigmaColor(context, 'Text', 'Primary')
                              : getFigmaColor(context, 'Text', 'Disabled'),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// LANGUAGE CARD
class LanguageCard extends StatelessWidget {
  const LanguageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
          elevation: 0,
          color: getFigmaColor(context, 'Primary', 'On Main'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.zero,
              bottomRight: Radius.zero,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Language',
                  style: AppTypography.labelSmall().copyWith(
                    color: getFigmaColor(context, 'Primary', 'Dark'),
                  ),
                ),
                SizedBox(height: 5),
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
        SizedBox(height: 1),
        Card(
          elevation: 0,
          margin: EdgeInsets.fromLTRB(4, 0, 4, 4),
          color: getFigmaColor(context, 'Primary', 'On Main'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
              topLeft: Radius.zero,
              topRight: Radius.zero,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transcription Language',
                  style: AppTypography.labelSmall().copyWith(
                    color: getFigmaColor(context, 'Primary', 'Dark'),
                  ),
                ),
                SizedBox(height: 5),
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

// FILTER STYLE
class FilterCard extends StatefulWidget {
  const FilterCard({super.key});

  @override
  State<FilterCard> createState() => _StateFilterCard();
}

class _StateFilterCard extends State<FilterCard> {
  int selectedRadioValue = 1; // Initialize to the first radio button's value
  
  @override
  Widget build(BuildContext context) {
    return AccordionCard(
      title: 'Filter Style',
      content: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    Radio<int>(
                      fillColor: selectedRadioValue == 1 ? WidgetStateProperty.all(getFigmaColor(context, 'Primary', 'Main')) : WidgetStateProperty.all(Color.fromARGB(255, 31, 31, 31)),
                      value: 1, // Unique value for this radio button
                      groupValue: selectedRadioValue,
                      onChanged: (int? value) {
                        setState(() {
                          selectedRadioValue = value!;
                        });
                      },
                    ),
                    Text(
                      'Style 1 - By Color',
                      style: AppTypography.bodyLarge().copyWith(
                        color: getFigmaColor(context, 'Primary', 'Dark'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    Radio<int>(                      
                      fillColor: selectedRadioValue != 1 ? WidgetStateProperty.all(getFigmaColor(context, 'Primary', 'Main')) : WidgetStateProperty.all(Color.fromARGB(255, 31, 31, 31)),
                      value: 2, // Unique value for this radio button
                      groupValue: selectedRadioValue,
                      onChanged: (int? value) {
                        setState(() {
                          selectedRadioValue = value!;
                        });
                      },
                    ),
                    Text(
                      'Style 2 - By Size',
                      style: AppTypography.bodyLarge().copyWith(
                        color: getFigmaColor(context, 'Primary', 'Dark'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
