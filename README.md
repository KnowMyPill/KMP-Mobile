# Pill

# Features

# Architecture

# Directory organization

```
📂lib
├─ main.dart
├─ index.dart
└─ 📂src
   ├─ 📂app
   │  ├─ app_lifecycle_reactor.dart
   │  ├─ background_service.dart
   │  └─ global_audio_player.dart
   ├─ 📂core
   │  ├─ internationalization.dart
   │  ├─ lat_lng.dart
   │  ├─ pillkaboo_model.dart
   │  ├─ pillkaboo_util.dart
   │  ├─ place.dart
   │  └─ uploaded_file.dart.dart
   ├─ 📂data
   │  └─ 📂local
   │     ├─ 📂database
   │     │  ├─ barcode_db_helper.dart
   │     │  ├─ children_db_helper.dart
   │     │  ├─ ingredients_db_helper.dart
   │     │  └─ processed_file_db_helper.dart
   │     └─ 📂shared_preference
   │        └─ app_state.dart
   ├─ 📂nav
   │  ├─ nav.dart
   │  └─ serialization_util.dart
   ├─ 📂network
   │  ├─ connectivity.dart
   │  └─ download_file.dart
   ├─ 📂ui
   │  ├─ 📂pages
   │  │     ├─ 📂liquid_med
   │  │     │   ├─ 📂check_rest
   │  │     │   │  ├─ 📂check_rest_page
   │  │     │   │  │  ├─ check_rest_page_model.dart
   │  │     │   │  │  └─ check_rest_page_widget.dart
   │  │     │   │  └─ 📂check_rest_result_page
   │  │     │   │     ├─ check_rest_result_page_model.dart
   │  │     │   │     └─ check_rest_result_page_widget.dart
   │  │     │   ├─ 📂liquid_med_submenu_page
   │  │     │   │  ├─ liquid_med_submenu_page_model.dart
   │  │     │   │  └─ liquid_med_submenu_page_widget.dart
   │  │     │   └─ 📂pour_right
   │  │     │      ├─ 📂pour_right_page
   │  │     │      │  ├─ pour_right_page_model.dart
   │  │     │      │  └─ pour_right_page_widget.dart
   │  │     │      ├─ 📂pour_right_result_page
   │  │     │      │  ├─ pour_right_result_page_model.dart
   │  │     │      │  └─ pour_right_result_page_widget.dart
   │  │     │      └─ 📂pour_right_slider_page
   │  │     │         ├─ pour_right_slider_page_model.dart
   │  │     │         └─ pour_right_slider_page_widget.dart
   │  │     ├─ 📂main_menu_page
   │  │     │  ├─ main_menu_page_model.dart
   │  │     │  └─ main_menu_page_widget.dart
   │  │     ├─ 📂med_recognition
   │  │     │   ├─ 📂med_info_recognition
   │  │     │   │  ├─ 📂med_recognition_page
   │  │     │   │  │  ├─ med_recognition_page_model.dart
   │  │     │   │  │  └─ med_recognition_page_widget.dart
   │  │     │   │  └─ 📂med_info_page
   │  │     │   │     ├─ med_info_page_model.dart
   │  │     │   │     └─ med_info_page_widget.dart
   │  │     │   ├─ 📂med_submenu_page
   │  │     │   │  ├─ med_submenu_page_model.dart
   │  │     │   │  └─ med_submenu_page_widget.dart
   │  │     │   └─ 📂prescribed_med
   │  │     │      ├─ 📂prescribed_med_recognition_page
   │  │     │      │  ├─ prescribed_med_recognition_page_model.dart
   │  │     │      │  └─ prescribed_med_recognition_page_widget.dart
   │  │     │      └─ 📂prescribed_med_result_page
   │  │     │         ├─ prescribed_med_result_page_model.dart
   │  │     │         └─ prescribed_med_result_page_widget.dart
   │  │     └─ 📂settings
   │  │         ├─ 📂allergy
   │  │         │  ├─ 📂allergy_add_page
   │  │         │  │  ├─ allergy_add_page_model.dart
   │  │         │  │  └─ allergy_add_page_widget.dart
   │  │         │  └─ 📂allergy_list_page
   │  │         │     ├─ allergy_list_page_model.dart
   │  │         │     └─ allergy_list_page_widget.dart
   │  │         ├─ 📂help_page
   │  │         │  ├─ help_page_model.dart
   │  │         │  └─ help_page_widget.dart
   │  │         ├─ 📂pick_color_page
   │  │         │  ├─ pick_color_page_model.dart
   │  │         │  └─ pick_color_page_widget.dart
   │  │         └─ 📂settings_menu_page
   │  │            ├─ settings_menu_page_model.dart
   │  │            └─ settings_menu_page_widget.dart
   │  ├─ 📂styles
   │  │  ├─ pillkaboo_icon_button.dart
   │  │  ├─ pillkaboo_theme.dart
   │  │  └─ pillkaboo_widgets.dart
   │  ├─ 📂widgets
   │  │  ├─ 📂components
   │  │  │  ├─ gesture_slider.dart
   │  │  │  └─ home_button_widget.dart
   │  │  ├─ 📂features
   │  │  │  ├─ check_rest_widget.dart
   │  │  │  ├─ med_recognizer_widget.dart
   │  │  │  ├─ pour_right_widget.dart
   │  │  │  └─ prescribed_med_recognizer_widget.dart
   │  │  ├─ 📂views
   │  │  │  ├─ barcode_detector_view.dart
   │  │  │  ├─ camera_view.dart
   │  │  │  ├─ detector_view.dart
   │  │  │  └─ text_detector_view.dart
   │  │  └─ pillkaboo_widgets.dart
   └─ 📂utils
      ├─ coordinates_translator.dart
      ├─ date_parser.dart
      └─ liquid_volume_estimator.dart
```

# Getting started
