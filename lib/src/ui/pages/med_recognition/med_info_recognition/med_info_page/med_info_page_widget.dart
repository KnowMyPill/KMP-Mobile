import 'package:pillkaboo/src/app/tts/tts_service.dart';
import '../../../../../app/global_audio_player.dart';
import '../../../../../core/pillkaboo_util.dart';
import '../../../../styles/pillkaboo_icon_button.dart';
import '../../../../styles/pillkaboo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'med_info_page_model.dart';
export 'med_info_page_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
class MedInfoPageWidget extends StatefulWidget {
  const MedInfoPageWidget({super.key});
  @override
  State<MedInfoPageWidget> createState() => _MedInfoPageWidgetState();
}
class _MedInfoPageWidgetState extends State<MedInfoPageWidget> {
  late MedInfoPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool showChildText = false;  
  bool showExprDateText = false;
  bool showIngredientText = false;
  bool showUsageText = false;
  bool showHowToTakeText = false;
  bool showWarningText = false;
  bool showComboText = false;
  bool showSideEffectText = false;

  double verticalSpace = 30.0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MedInfoPageModel());
    TtsService().stop();
    GlobalAudioPlayer().playOnce();
  }
  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
  void clearAndNavigate(BuildContext context) {
    TtsService().stop();
    while (context.canPop() == true) {
      context.pop();
    }
    context.pushReplacement('/mainMenuPage');
  }
  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }
    context.watch<PKBAppState>();
    String childText = '', exprDateText = '', ingredientText = '', usageText = '', howToTakeText = '', warningText = '', comboText = '', sideEffectText = '';
    
    if (PKBAppState().foundAllergies == '') {
      childText = '등록하신 알러지 해당하는 주성분이 없습니다.';
    } else {
      childText = '${PKBAppState().foundAllergies} 알러지를 주의해주세요.';
    }
    if (PKBAppState().infoExprDate == '') {
      exprDateText = '해당 약의 사용기한 정보가 없습니다.';
    } else {
      exprDateText = '사용기한 ${PKBAppState().infoExprDate}까지';
    }
    if (PKBAppState().infoIngredient == '') {
      ingredientText = '해당 약의 주성분 정보가 없습니다.';
    } else {
      ingredientText = '주성분 ${PKBAppState().infoIngredient}';
    }
    if (PKBAppState().infoUsage == '') {
      usageText = '해당 약의 용도 정보가 없습니다.';
    } else {
      usageText = '용도 ${PKBAppState().infoUsage}';
    }
    if (PKBAppState().infoHowToTake == '') {
      howToTakeText = '해당 약의 복용방법 정보가 없습니다.';
    } else {
      howToTakeText = '복용방법 ${PKBAppState().infoHowToTake}';
    }
    if (PKBAppState().infoWarning == '') {
      warningText = '해당 약의 주의사항 정보가 없습니다.';
    } else {
      warningText = '주의사항 ${PKBAppState().infoWarning}';
    }
    if (PKBAppState().infoCombo == '') {
      comboText = '해당 약의 금지조합 정보가 없습니다.';
    } else {
      comboText = '금지조합 ${PKBAppState().infoCombo}';
    }
    if (PKBAppState().infoSideEffect == '') {
      sideEffectText = '해당 약의 부작용 정보가 없습니다.';
    } else {
      sideEffectText = '부작용 ${PKBAppState().infoSideEffect}';
    }

    double imageContainerSize = 65.0/892.0 * MediaQuery.of(context).size.height;
    double backIconSize = 30.0/892.0 * MediaQuery.of(context).size.height;
    double appBarFontSize = 32.0/892.0 * MediaQuery.of(context).size.height;
    double textFontSize = 30.0/892.0 * MediaQuery.of(context).size.height;

    return GestureDetector(
        onTap: () => _model.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(_model.unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: PKBAppState().tertiaryColor,
          appBar: AppBar(
            backgroundColor: PKBAppState().tertiaryColor,
            automaticallyImplyLeading: false,
            title: Semantics(
              container: true,
              label: '이 약은 ${PKBAppState().infoMedName}입니다',
              child: ExcludeSemantics(
                excluding: true,
                child: Text(
                  PKBAppState().infoMedName,
                  style: PillKaBooTheme.of(context).headlineMedium.override(
                    fontFamily: PillKaBooTheme.of(context).headlineMediumFamily,
                    color: PKBAppState().secondaryColor,
                    fontSize: appBarFontSize,
                    fontWeight: FontWeight.bold,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(PillKaBooTheme.of(context).headlineMediumFamily),
                  ),
                ),
              ),
            ),
            actions: [
              Semantics(
                label: '홈으로 가기. 실행하려면 두번 누르세요',
                child: ExcludeSemantics(
                  excluding: true,
                  child: PillKaBooIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 60.0,
                    icon: Icon(
                      Icons.home,
                      color: PKBAppState().secondaryColor,
                      size: backIconSize,
                    ),
                    onPressed: () async {
                      setState(() {
                        PKBAppState().infoMedName = "";
                        PKBAppState().infoExprDate = "";
                        PKBAppState().infoUsage = "";
                        PKBAppState().infoHowToTake = "";
                        PKBAppState().infoWarning = "";
                        PKBAppState().infoCombo = "";
                        PKBAppState().infoSideEffect = "";
                        PKBAppState().infoIngredient = "";
                        PKBAppState().infoChild = "";
                        PKBAppState().foundAllergies = "";
                      });
                      clearAndNavigate(context);
                    },
                  ),
                ),
              ),
            ],
            centerTitle: false,
            elevation: 2.0,
          ),
          body: SafeArea(
          top: true,
          child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.87,
            child: SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              Semantics(
                container: true,
                label: childText,
                child: InkWell(
                  child: ExcludeSemantics(
                    excluding: true,
                    child: GestureDetector(
                      onTap: () {
                        if (!PKBAppState().useScreenReader) {
                          TtsService().stop();
                          TtsService().speak(childText);
                        }
                      },
                      onDoubleTap: () {
                        setState(() {
                          showChildText = !showChildText;
                        
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ExcludeSemantics(
                          excluding: true,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 40.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: imageContainerSize,
                                height: imageContainerSize,
                                decoration: BoxDecoration(
                                  color: PKBAppState().secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    'assets/images/allergy.svg',
                                    fit: BoxFit.contain,
                                    colorFilter: ColorFilter.mode(
                                      PKBAppState().tertiaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ExcludeSemantics(
                          excluding: true,
                          child: Text(
                          '알러지',
                          style: PillKaBooTheme.of(context).titleMedium.override(
                                fontFamily:
                                    PillKaBooTheme.of(context).titleMediumFamily,
                                fontSize: textFontSize,
                            color: PKBAppState().secondaryColor,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    PillKaBooTheme.of(context).titleMediumFamily),
                              ),
                          ),
                        ),
                      
                        
                      ],
                      ),
                      Visibility(
                          visible: showChildText,
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            childText,    
                            style: TextStyle(
                              color: PKBAppState().secondaryColor,
                              fontSize: 20,
                            ),
                          ),
                          ),
                        ),
                        ],
                    ),
                  ),
                ),
                ),
              ),
              
              const SizedBox(height: 25),
              Semantics(
                container: true,
                label: exprDateText,
                child: InkWell(
                  child: ExcludeSemantics(
                    excluding: true,
                    child: GestureDetector(
                      onTap: () {
                        if (!PKBAppState().useScreenReader) {
                          TtsService().stop();
                          TtsService().speak(exprDateText);
                        }
                      },
                      onDoubleTap: () {
                        setState(() {
                          showExprDateText = !showExprDateText;
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ExcludeSemantics(
                          excluding: true,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 40.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: imageContainerSize,
                                height: imageContainerSize,
                                decoration: BoxDecoration(
                                  color: PKBAppState().secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    'assets/images/date.svg',
                                    fit: BoxFit.contain,
                                    colorFilter: ColorFilter.mode(
                                      PKBAppState().tertiaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ExcludeSemantics(
                          excluding: true,
                          child: Text(
                          '사용 기한',
                          style: PillKaBooTheme.of(context).titleMedium.override(
                                fontFamily:
                                    PillKaBooTheme.of(context).titleMediumFamily,
                                fontSize: textFontSize,
                            color: PKBAppState().secondaryColor,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    PillKaBooTheme.of(context).titleMediumFamily),
                              ),
                          ),
                        ),
                      ],
                      ),
                      Visibility(
                          visible: showExprDateText,
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            exprDateText,    
                            style: TextStyle(
                              color: PKBAppState().secondaryColor,
                              fontSize: 20,
                            ),
                          ),
                          ),
                        ),
                        ],
                    ),
                  ),
                ),
                ),
              ),
              
              const SizedBox(height: 25),
              Semantics(
                container: true,
                label: ingredientText,
                child: InkWell(
                  child: ExcludeSemantics(
                    excluding: true,
                    child: GestureDetector(
                      onTap: () {
                        if (!PKBAppState().useScreenReader) {
                          TtsService().stop();
                          TtsService().speak(ingredientText);
                        }
                      },
                      onDoubleTap: () {
                        setState(() {
                          showIngredientText = !showIngredientText;
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ExcludeSemantics(
                          excluding: true,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 40.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: imageContainerSize,
                                height: imageContainerSize,
                                decoration: BoxDecoration(
                                  color: PKBAppState().secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    'assets/images/ing.svg',
                                    fit: BoxFit.contain,
                                    colorFilter: ColorFilter.mode(
                                      PKBAppState().tertiaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ExcludeSemantics(
                          excluding: true,
                          child: Text(
                          '주성분',
                          style: PillKaBooTheme.of(context).titleMedium.override(
                                fontFamily:
                                    PillKaBooTheme.of(context).titleMediumFamily,
                                fontSize: textFontSize,
                            color: PKBAppState().secondaryColor,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    PillKaBooTheme.of(context).titleMediumFamily),
                              ),
                          ),
                        ),
                      ],
                      ),
                      Visibility(
                          visible: showIngredientText,
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ingredientText,    
                            style: TextStyle(
                              color: PKBAppState().secondaryColor,
                              fontSize: 20,
                            ),
                          ),
                          ),
                        ),
                        ],
                    ),
                  ),
                ),
                ),
              ),
              
              const SizedBox(height: 25),
              Semantics(
                container: true,
                label: usageText,
                child: InkWell(
                  child: ExcludeSemantics(
                    excluding: true,
                    child: GestureDetector(
                      onTap: () {
                        if (!PKBAppState().useScreenReader) {
                          TtsService().stop();
                          TtsService().speak(usageText);
                        }
                      },
                      onDoubleTap: () {
                        setState(() {
                          showUsageText = !showUsageText;
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ExcludeSemantics(
                          excluding: true,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 40.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: imageContainerSize,
                                height: imageContainerSize,
                                decoration: BoxDecoration(
                                  color: PKBAppState().secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    'assets/images/use.svg',
                                    fit: BoxFit.contain,
                                    colorFilter: ColorFilter.mode(
                                      PKBAppState().tertiaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ExcludeSemantics(
                          excluding: true,
                          child: Text(
                          '용도',
                          style: PillKaBooTheme.of(context).titleMedium.override(
                                fontFamily:
                                    PillKaBooTheme.of(context).titleMediumFamily,
                                fontSize: textFontSize,
                            color: PKBAppState().secondaryColor,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    PillKaBooTheme.of(context).titleMediumFamily),
                              ),
                          ),
                        ),
                      ],
                      ),
                      Visibility(
                          visible: showUsageText,
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            usageText,    
                            style: TextStyle(
                              color: PKBAppState().secondaryColor,
                              fontSize: 20,
                            ),
                          ),
                          ),
                        ),
                        ],
                    ),
                  ),
                ),
                ),
              ),
              
              const SizedBox(height: 25),
              Semantics(
                container: true,
                label: howToTakeText,
                child: InkWell(
                  child: ExcludeSemantics(
                    excluding: true,
                    child: GestureDetector(
                      onTap: () {
                        if (!PKBAppState().useScreenReader) {
                          TtsService().stop();
                          TtsService().speak(howToTakeText);
                        }
                      },
                      onDoubleTap: () {
                        setState(() {
                          showHowToTakeText = !showHowToTakeText;
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ExcludeSemantics(
                          excluding: true,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 40.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: imageContainerSize,
                                height: imageContainerSize,
                                decoration: BoxDecoration(
                                  color: PKBAppState().secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    'assets/images/howeat.svg',
                                    fit: BoxFit.contain,
                                    colorFilter: ColorFilter.mode(
                                      PKBAppState().tertiaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ExcludeSemantics(
                          excluding: true,
                          child: Text(
                          '복용 방법',
                          style: PillKaBooTheme.of(context).titleMedium.override(
                                fontFamily:
                                    PillKaBooTheme.of(context).titleMediumFamily,
                                fontSize: textFontSize,
                            color: PKBAppState().secondaryColor,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    PillKaBooTheme.of(context).titleMediumFamily),
                              ),
                          ),
                        ),
                      ],
                      ),
                      Visibility(
                          visible: showHowToTakeText,
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            howToTakeText,    
                            style: TextStyle(
                              color: PKBAppState().secondaryColor,
                              fontSize: 20,
                            ),
                          ),
                          ),
                        ),
                        ],
                    ),
                  ),
                ),
                ),
              ),
              
              const SizedBox(height: 25),
              Semantics(
                container: true,
                label: warningText,
                child: InkWell(
                  child: ExcludeSemantics(
                    excluding: true,
                    child: GestureDetector(
                      onTap: () {
                        if (!PKBAppState().useScreenReader) {
                          TtsService().stop();
                          TtsService().speak(warningText);
                        }
                      },
                      onDoubleTap: () {
                        setState(() {
                          showWarningText = !showWarningText;
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ExcludeSemantics(
                          excluding: true,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 40.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: imageContainerSize,
                                height: imageContainerSize,
                                decoration: BoxDecoration(
                                  color: PKBAppState().secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    'assets/images/warning.svg',
                                    fit: BoxFit.contain,
                                    colorFilter: ColorFilter.mode(
                                      PKBAppState().tertiaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ExcludeSemantics(
                          excluding: true,
                          child: Text(
                          '주의사항',
                          style: PillKaBooTheme.of(context).titleMedium.override(
                                fontFamily:
                                    PillKaBooTheme.of(context).titleMediumFamily,
                                fontSize: textFontSize,
                            color: PKBAppState().secondaryColor,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    PillKaBooTheme.of(context).titleMediumFamily),
                              ),
                          ),
                        ),
                      ],
                      ),
                      Visibility(
                          visible: showWarningText,
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            warningText,    
                            style: TextStyle(
                              color: PKBAppState().secondaryColor,
                              fontSize: 20,
                            ),
                          ),
                          ),
                        ),
                        ],
                    ),
                  ),
                ),
                ),
              ),
              
              const SizedBox(height: 25),
              Semantics(
                container: true,
                label: comboText,
                child: InkWell(
                  child: ExcludeSemantics(
                    excluding: true,
                    child: GestureDetector(
                      onTap: () {
                        if (!PKBAppState().useScreenReader) {
                          TtsService().stop();
                          TtsService().speak(comboText);
                        }
                      },
                      onDoubleTap: () {
                        setState(() {
                          showComboText = !showComboText;
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ExcludeSemantics(
                          excluding: true,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 40.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: imageContainerSize,
                                height: imageContainerSize,
                                decoration: BoxDecoration(
                                  color: PKBAppState().secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    'assets/images/forb.svg',
                                    fit: BoxFit.contain,
                                    colorFilter: ColorFilter.mode(
                                      PKBAppState().tertiaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ExcludeSemantics(
                          excluding: true,
                          child: Text(
                          '금지 조합',
                          style: PillKaBooTheme.of(context).titleMedium.override(
                                fontFamily:
                                    PillKaBooTheme.of(context).titleMediumFamily,
                                fontSize: textFontSize,
                            color: PKBAppState().secondaryColor,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    PillKaBooTheme.of(context).titleMediumFamily),
                              ),
                          ),
                        ),
                      ],
                      ),
                      Visibility(
                          visible: showComboText,
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            comboText,    
                            style: TextStyle(
                              color: PKBAppState().secondaryColor,
                              fontSize: 20,
                            ),
                          ),
                          ),
                        ),
                        ],
                    ),
                  ),
                ),
                ),
              ),
              
              const SizedBox(height: 25),
              Semantics(
                container: true,
                label: sideEffectText,
                child: InkWell(
                  child: ExcludeSemantics(
                    excluding: true,
                    child: GestureDetector(
                      onTap: () {
                        if (!PKBAppState().useScreenReader) {
                          TtsService().stop();
                          TtsService().speak(sideEffectText);
                        }
                      },
                      onDoubleTap: () {
                        setState(() {
                          showSideEffectText = !showSideEffectText;
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ExcludeSemantics(
                          excluding: true,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 40.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: imageContainerSize,
                                height: imageContainerSize,
                                decoration: BoxDecoration(
                                  color: PKBAppState().secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    'assets/images/sideef.svg',
                                    fit: BoxFit.contain,
                                    colorFilter: ColorFilter.mode(
                                      PKBAppState().tertiaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ExcludeSemantics(
                          excluding: true,
                          child: Text(
                          '부작용',
                          style: PillKaBooTheme.of(context).titleMedium.override(
                                fontFamily:
                                    PillKaBooTheme.of(context).titleMediumFamily,
                                fontSize: textFontSize,
                            color: PKBAppState().secondaryColor,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    PillKaBooTheme.of(context).titleMediumFamily),
                              ),
                          ),
                        ),
                      ],
                      ),
                      Visibility(
                          visible: showSideEffectText,
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            sideEffectText,    
                            style: TextStyle(
                              color: PKBAppState().secondaryColor,
                              fontSize: 20,
                            ),
                          ),
                          ),
                        ),
                        ],
                    ),
                  ),
                ),
                ),
              ),
                        ],
          ),
        ),
      ),
          )
        ),
    );
  }
}