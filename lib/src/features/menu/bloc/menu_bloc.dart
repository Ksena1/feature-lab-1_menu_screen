import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/menu/data/category_repository.dart';
import 'package:flutter_course/src/features/menu/data/menu_repository.dart';
import 'package:flutter_course/src/features/menu/models/menu_category.dart';
import 'package:flutter_course/src/features/menu/models/menu_item.dart';

part 'menu_event.dart';
part 'menu_state.dart';

const _pageLimit = 25;

final class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final IMenuRepository _menuRepository;
  final ICategoryRepository _categoryRepository;

  MenuCategory? _currentPaginatedCategory;
  int _currentPage = 0;
  final List<MenuItem> _loadedItems = [];

  MenuBloc({
    required IMenuRepository menuRepository,
    required ICategoryRepository categoryRepository,
  })  : _menuRepository = menuRepository,
        _categoryRepository = categoryRepository,
        super(const IdleMenuState()) {
    on<LoadCategoriesEvent>(_loadCategories);
    on<LoadPageEvent>(_loadMenuItems);
  }

  Future<void> _loadCategories(LoadCategoriesEvent event, Emitter<MenuState> emit) async {
    emit(ProgressMenuState(items: state.items));
    
    try {
      final categories = await _categoryRepository.loadCategories();
      
      if (categories.isNotEmpty) {
        _currentPaginatedCategory = categories.first;
        _currentPage = 0;
        _loadedItems.clear();
      }
      
      emit(SuccessfulMenuState(
        categories: categories,
        items: _loadedItems,
      ));
    } catch (e) {
      emit(ErrorMenuState(
        categories: state.categories,
        items: state.items,
      ));
    } finally {
      emit(IdleMenuState(
        categories: state.categories,
        items: state.items,
      ));
    }
  }

  Future<void> _loadMenuItems(LoadPageEvent event, Emitter<MenuState> emit) async {
    if (_currentPaginatedCategory == null) return;
    
    emit(ProgressMenuState(
      categories: state.categories,
      items: state.items,
    ));

    try {
      final newItems = await _menuRepository.loadMenuItems(
        category: _currentPaginatedCategory!,
        page: _currentPage,
        limit: _pageLimit,
      );

      _loadedItems.addAll(newItems);
      
      // Если загружено меньше items чем лимит - переходим к следующей категории
      if (newItems.length < _pageLimit) {
        _moveToNextCategory(state.categories ?? []);
        _currentPage = 0;
      } else {
        _currentPage++;
      }

      emit(SuccessfulMenuState(
        categories: state.categories,
        items: List.from(_loadedItems),
      ));
    } catch (e) {
      emit(ErrorMenuState(
        categories: state.categories,
        items: state.items,
      ));
    } finally {
      emit(IdleMenuState(
        categories: state.categories,
        items: state.items,
      ));
    }
  }

  void _moveToNextCategory(List<MenuCategory> categories) {
    if (categories.isEmpty) return;
    
    final currentIndex = categories.indexWhere(
      (category) => category.id == _currentPaginatedCategory?.id,
    );
    
    if (currentIndex != -1 && currentIndex < categories.length - 1) {
      _currentPaginatedCategory = categories[currentIndex + 1];
    } else {
      _currentPaginatedCategory = null; // Все категории обработаны
    }
    
    _loadedItems.clear();
  }
}