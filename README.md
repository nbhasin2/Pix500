# Pix500
Pix500 is a photo app built on top of 500px Api

- Paginated UICollectionView 
- Paginated DetailView 
- Custom animation for closing and opening the detailview. 
- Can set aspect ratio for the grid cells by uncommenting line 182 in GridViewController.swift
- Added XCTest for checking route

What can be improved ?
- Scrolling can be improved. Instead of fetching at the end of view we can easily fetch items while view is being scrolled. This will allow smooth scrolling. 
- Reloading can be improved. 
