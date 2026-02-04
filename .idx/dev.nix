{ pkgs, ... }: {
  channel = "stable-23.11";
  packages = [
    pkgs.flutter
    pkgs.dart
    pkgs.jdk17
    pkgs.zip
    pkgs.gnutar
  ];
  idx.extensions = [
    "Dart-Code.flutter"
    "Dart-Code.dart-code"
  ];
  idx.previews = {
    enable = true;
    previews = {
      android = {
        command = [ "flutter" "run" "--machine" "-d" "android" "-d" "emulator-5554" ];
        manager = "android";
      };
    };
  };
}
