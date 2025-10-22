import 'package:flutter/material.dart';

class CategoryTabs extends StatefulWidget {
  final List<String> categories;
  final String activeCategory;
  final Function(String) onCategorySelected;
  final ScrollController scrollController;

  const CategoryTabs({
    Key? key,
    required this.categories,
    required this.activeCategory,
    required this.onCategorySelected,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  @override
  void didUpdateWidget(CategoryTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.activeCategory != oldWidget.activeCategory) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToActiveCategory();
      });
    }
  }

  void _scrollToActiveCategory() {
    final index = widget.categories.indexOf(widget.activeCategory);
    if (index != -1) {
      final itemWidth = 120.0;
      final screenWidth = MediaQuery.of(context).size.width;
      final offset = (itemWidth * index) - (screenWidth / 2 - itemWidth / 2);
      
      widget.scrollController.animateTo(
        offset.clamp(0.0, widget.scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, 
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        controller: widget.scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isActive = category == widget.activeCategory;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: GestureDetector(
              onTap: () => widget.onCategorySelected(category),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: isActive ? Theme.of(context).colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: isActive 
                      ? Theme.of(context).colorScheme.primary 
                      : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}