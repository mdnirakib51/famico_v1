// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsAppIconsGen {
  const $AssetsAppIconsGen();

  /// File path: assets/app_icons/app_logo_ic.jpeg
  AssetGenImage get appLogoIc =>
      const AssetGenImage('assets/app_icons/app_logo_ic.jpeg');

  /// File path: assets/app_icons/family_tree.png
  AssetGenImage get familyTree =>
      const AssetGenImage('assets/app_icons/family_tree.png');

  /// File path: assets/app_icons/family_tree_ic.png
  AssetGenImage get familyTreeIc =>
      const AssetGenImage('assets/app_icons/family_tree_ic.png');

  /// File path: assets/app_icons/make_relationship_ic.png
  AssetGenImage get makeRelationshipIc =>
      const AssetGenImage('assets/app_icons/make_relationship_ic.png');

  /// File path: assets/app_icons/profile_ic.png
  AssetGenImage get profileIc =>
      const AssetGenImage('assets/app_icons/profile_ic.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    appLogoIc,
    familyTree,
    familyTreeIc,
    makeRelationshipIc,
    profileIc,
  ];
}

class $AssetsAppImagesGen {
  const $AssetsAppImagesGen();

  /// File path: assets/app_images/on_board_1.jpeg
  AssetGenImage get onBoard1 =>
      const AssetGenImage('assets/app_images/on_board_1.jpeg');

  /// File path: assets/app_images/on_board_2.jpeg
  AssetGenImage get onBoard2 =>
      const AssetGenImage('assets/app_images/on_board_2.jpeg');

  /// File path: assets/app_images/on_board_3.jpeg
  AssetGenImage get onBoard3 =>
      const AssetGenImage('assets/app_images/on_board_3.jpeg');

  /// File path: assets/app_images/on_board_back_img.jpg
  AssetGenImage get onBoardBackImg =>
      const AssetGenImage('assets/app_images/on_board_back_img.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [
    onBoard1,
    onBoard2,
    onBoard3,
    onBoardBackImg,
  ];
}

class $AssetsRequiredSrcGen {
  const $AssetsRequiredSrcGen();

  /// File path: assets/required_src/calendar_ic.png
  AssetGenImage get calendarIc =>
      const AssetGenImage('assets/required_src/calendar_ic.png');

  /// File path: assets/required_src/close_ic.png
  AssetGenImage get closeIc =>
      const AssetGenImage('assets/required_src/close_ic.png');

  /// File path: assets/required_src/delete_ic.png
  AssetGenImage get deleteIc =>
      const AssetGenImage('assets/required_src/delete_ic.png');

  /// File path: assets/required_src/empty_ic.png
  AssetGenImage get emptyIc =>
      const AssetGenImage('assets/required_src/empty_ic.png');

  /// File path: assets/required_src/scanner.png
  AssetGenImage get scanner =>
      const AssetGenImage('assets/required_src/scanner.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    calendarIc,
    closeIc,
    deleteIc,
    emptyIc,
    scanner,
  ];
}

class $AssetsSocialIcGen {
  const $AssetsSocialIcGen();

  /// File path: assets/social_ic/facebook_ic.png
  AssetGenImage get facebookIc =>
      const AssetGenImage('assets/social_ic/facebook_ic.png');

  /// File path: assets/social_ic/google_ic.png
  AssetGenImage get googleIc =>
      const AssetGenImage('assets/social_ic/google_ic.png');

  /// File path: assets/social_ic/linkedin.png
  AssetGenImage get linkedin =>
      const AssetGenImage('assets/social_ic/linkedin.png');

  /// List of all assets
  List<AssetGenImage> get values => [facebookIc, googleIc, linkedin];
}

class Assets {
  const Assets._();

  static const $AssetsAppIconsGen appIcons = $AssetsAppIconsGen();
  static const $AssetsAppImagesGen appImages = $AssetsAppImagesGen();
  static const $AssetsRequiredSrcGen requiredSrc = $AssetsRequiredSrcGen();
  static const $AssetsSocialIcGen socialIc = $AssetsSocialIcGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
