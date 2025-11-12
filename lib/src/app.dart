import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/menu/data/data_sources/database_helper.dart';
import 'package:flutter_course/src/features/menu/data/data_sources/savable_categories_data_source.dart';
import 'package:flutter_course/src/features/menu/data/data_sources/savable_menu_data_source.dart';
import 'package:flutter_course/src/features/menu/data/category_repository.dart';
import 'package:flutter_course/src/features/menu/data/menu_repository.dart';
import 'package:flutter_course/src/features/menu/bloc/menu_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Database
        Provider<DatabaseHelper>(create: (_) => DatabaseHelper.instance),
        
        // Data Sources
        Provider<ISavableCategoriesDataSource>(
          create: (context) => SavableCategoriesDataSource(
            databaseHelper: context.read<DatabaseHelper>(),
          ),
        ),
        Provider<ISavableMenuDataSource>(
          create: (context) => SavableMenuDataSource(
            databaseHelper: context.read<DatabaseHelper>(),
          ),
        ),

        // Repository
        Provider<ICategoryRepository>(
          create: (context) => CategoriesRepository(
            networkCategoriesDataSource: // добавьте ваш сетевой data source,
            dbCategoriesDataSource: context.read<ISavableCategoriesDataSource>(),
          ),
        ),
        Provider<IMenuRepository>(
          create: (context) => MenuRepository(
            networkMenuDataSource: // добавьте ваш сетевой data source,
            dbMenuDataSource: context.read<ISavableMenuDataSource>(),
          ),
        ),

        // BLoC
        BlocProvider<MenuBloc>(
          create: (context) => MenuBloc(
            menuRepository: context.read<IMenuRepository>(),
            categoryRepository: context.read<ICategoryRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Menu App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: // ваша главная страница,
      ),
    );
  }
}