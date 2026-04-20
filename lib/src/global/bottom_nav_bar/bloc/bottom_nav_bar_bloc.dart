
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/address/bloc/address_bloc.dart';
import '../../../features/address/bloc/address_event.dart';
import '../../../features/address/view/address_screen.dart';
import '../../../features/family/family_tree/view/family_tree_screen.dart';
import '../../../features/family/make_relationship/view/make_relationship_screen.dart';
import '../../../features/user/profile/view/profile_screen.dart';
import '../../../features/user/profile_menu_screen.dart';
import 'bottom_nav_bar_event.dart';
import 'bottom_nav_bar_state.dart';

// ─── Nav Item Model ───────────────────────────────────────────────────────────
class NavItemModel {
  final String title;
  final IconData icon;

  NavItemModel({required this.title, required this.icon});
}

// ─── Dashboard Bloc ───────────────────────────────────────────────────────────
class BottomNavBarBloc extends Bloc<BottomNavBarEvent, BottomNavBarState> {

  final List<NavItemModel> navItems = [
    NavItemModel(title: 'Family Tree', icon: Icons.account_tree),       // index 0 — center
    NavItemModel(title: 'Make Relationship', icon: Icons.people_alt_rounded), // index 1 — left
    NavItemModel(title: 'Profile', icon: Icons.person_rounded),         // index 2 — right
  ];

  final List<Widget> screens = [
    FamilyTreeScreen(),        // index 0
    MakeRelationshipScreen(),  // index 1
    const ProfileMenuScreen(), // index 2
  ];

  BottomNavBarBloc() : super(const BottomNavBarState()) {
    on<BottomNavBarTabChanged>(_onTabChanged);
  }

  void _onTabChanged(BottomNavBarTabChanged event, Emitter<BottomNavBarState> emit) {
    if (state.selectedIndex == event.index) return;
    emit(state.copyWith(selectedIndex: event.index));
  }
}
