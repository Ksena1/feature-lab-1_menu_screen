part of "menu_bloc.dart";

sealed class MenuState {
  final List<MenuCategory>? categories;
  final List<MenuItem>? items;

  const MenuState({this.categories, this.items});
}

final class ProgressMenuState extends MenuState {
  const ProgressMenuState({super.categories, super.items});
}

final class SuccessfulMenuState extends MenuState {
  const SuccessfulMenuState({super.categories, super.items});
}

final class ErrorMenuState extends MenuState {
  const ErrorMenuState({super.categories, super.items});
}

final class IdleMenuState extends MenuState {
  const IdleMenuState({super.categories, super.items});
}