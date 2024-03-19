<img src="https://github.com/becooq81/PillKaBoo-HomePage/blob/main/assets/%EC%8D%B8%EB%84%A4%EC%9D%BC.png" alt="PillKaBoo Logo" width="850" height="478.125">

![header](https://capsule-render.vercel.app/api?type=waving&color=F2E99D&height=250&section=header&text=Pill%20Ka%20Boo&fontAlign=20&fontAlignY=35&fontSize=50&fontColor=000000&animation=scaleIn&desc=:%20safe%20and%20independent%20medication%20for%20blind%20and%20VI%20parents&descAlign=37&descAlignY=50)

## PillKaB👀

|**Medication Recognition**|**Medication Information**|**Recognition of Prescription Time Label**|
|:---:|:---:|:---:|
|![Medication Recognition](https://github.com/becooq81/PillKaBoo-HomePage/assets/81180021/8eb504c7-9229-41e7-9223-a5c85498763c) |  ![Medication Information](https://github.com/becooq81/PillKaBoo-HomePage/assets/81180021/fc74483f-95ec-4e9f-9ed3-bfa33f0f6256) | ![Presription Time Label](https://github.com/becooq81/PillKaBoo-HomePage/assets/81180021/9737dcc8-fbcd-4e0b-85d7-8db71e9f10f1) |

<br><br>

|**Accurate Liquid Medication Intake**|**Remaining Liquid Medication**|
|:---:|:---:|
| <img src="https://github.com/becooq81/PillKaBoo-HomePage/assets/81180021/7b765b8c-b67e-409f-b431-f530c05e0152" width="300" height="653"/> | <img src="https://github.com/becooq81/PillKaBoo-HomePage/assets/81180021/dccf778a-8dc9-4209-b208-1b79138cdb10" width="300" height="653"/>|

<br><br>

|**Settings - Register Allergies**|**Settings - Customize Colors**|**Settings - Guide**|
|:---:|:--:|:--:|
| ![Setting - Register Allergies](https://github.com/becooq81/PillKaBoo-HomePage/assets/81180021/c2bd3c78-50b2-4687-9f35-27e08e345448) | ![Settings-Customize Colors](https://github.com/becooq81/PillKaBoo-HomePage/assets/81180021/7874fec9-1e77-49fe-9d35-cd09c39400e3)|![Settings-Guide](https://github.com/becooq81/PillKaBoo-HomePage/assets/81180021/534f3933-6e3b-4ef7-be98-878a6a9bfcd2)|

## Features

✅ Recognize medication and retrieve information, such as child-specific warnings, dosage, expiry dates, allergy warnings for allergies you registered, etc. <br>
✅ Recognize prescribed medication packets to identify which part of the day for which the medicine is, and the prescription date<br>
✅ Pour the desired amount of liquid medication while being notified through audio feedback quickening as you approach the amount<br>
✅ Check the remaining amount of liquid medication in the container<br>
✅ Register your child's allergies to be warned of potential allergic reactions along with the child-specific warnings
✅ Customize the color options to suit your color visibility

## Architecture

Inspired by MVVM & Clean Architecture

## ML

Our custom ML model is integrated into this repository with TensorFlow Lite. 

`assets/yolov8n.tflite`


## Directory organization

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

## Getting started

PillKaBoo is on App Store and Google Play Store in South Korea
  - Currently, our service is only available in Korean and (in the case of medication recognition feature) medicine products registered in South Korea. We plan to expand the service internationally. In the meantime, send us an email if you wish the service in your country sooner! <br><br>



## How to run code

1. `git clone ...` <br>
2. `git pull origin main` <br>
3. `flutter pub get`<br>
4. `flutter run`<br>

### Requirements

`sdk: ">=3.0.0 <4.0.0"` <br>
