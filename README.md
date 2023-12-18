# Presentation Layer
- MVVM 아키텍처를 채택해서 View와 ViewModel의 의존성을 최대한 분리했습니다.
## 📁 폴더 구조
```
|____Presentation
| |____MainTabBarController.swift
| |____PhotoTab
| | |____PhotoDetailView
| | | |____PhotoDetailCollectionViewDataSource.swift
| | | |____PhotoDetailViewController.swift
| | | |____Cell
| | | | |____PhotoDetailCollectionViewCell.swift
| | | |____PhotoDetailViewModel.swift
| | |____PhotoListView
| | | |____PhotoListViewModel.swift
| | | |____Cell
| | | | |____PhotoListCollectionViewCell.swift
| | | |____PhotoListViewController.swift
| | | |____PhotoListCollectionViewDataSource.swift
| |____LoginTab
| | |____LoginNavigationController.swift
| | |____JoinViewController
| | | |____JoinViewController.swift
| | |____ResetPasswordViewController
| | | |____ResetPasswordViewController.swift
| | |____LoginViewController.swift
| |____SearchTab
| | |____SearchViewController.swift
| | |____SearchViewModel.swift
| | |____Cell
| | | |____SearchDiscoverColletionViewCell.swift
| | | |____SearchMainCollectionViewHeader.swift
| | | |____SearchCategoryCollectionViewCell.swift
| | |____SearchResultView
| | | |____SearchResultViewController.swift
| | | |____Cell
| | | | |____SearchCollectionCell.swift
| | | | |____SearchUserCell.swift
| | | |____SearchResultCollectionViewDataSource.swift
| | | |____SearchResultViewModel.swift
| | |____SearchNavigationController.swift
| | |____SearchViewDataSource.swift
```


## MVVM 아키텍처

### Closure를 활용한 Binding
```swift
// ListVM
var photos: [Photo] = [] {
    didSet {
      photosHandler?(photos)
    }
}
var photosHandler: (([Photo]) -> Void)?

// ListVC
func bind() {
    viewModel.bindPhotos(closure: { [weak self] photos in
      self?.photoListViewDataSource.photos = photos
      self?.updateCollectionView()
    })
}
```

### ViewModel간 데이터 통신
- MVVM패턴에 있어 View는 말그대로 UI적인 요소만 알고 있어야 한다고 생각해 VC간 직접적으로 데이터를 전달하지 않고, 데이터 통신은 ViewModel에서만 일어나는게 적합하다고 판단했습니다.
- ListVM에 사진목록과 현재 index가 저장된 상태의 DetailVM을 반환하는 메서드를 만들어, ListVC에서 Item이 select되었을 때 호출하여 DetailVC를 보여주게끔 설계했습니다.
```swift
// PhotoListViewModel
func carryData(photos: [Photo], index: Int) -> PhotoDetailViewModel {
    let detailViewModel = PhotoDetailViewModel()
    detailViewModel.photos = photos
    detailViewModel.carriedIndex = index
    return detailViewModel
}

// PhotoListViewController
PhotoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVM = viewModel.carryData(photos: viewModel.photos, index: indexPath.row)
        let detailVC = PhotoDetailViewController(viewModel: detailVM)
        detailVC.modalPresentationStyle = .overFullScreen
        self.present(detailVC, animated: true)
    }
}
```


## UX를 고려한 Animation 및 Layout

### PhotoListView Animation
- UX를 고려해 사진 목록을 아래로 스와이프할 때는 사진을 가리는 View의 아래 TabBar를 숨겼고, 다시 위로 스와이프하면 TabBar가 다시 나타나게 하는 애니메이션을 구현했습니다.
- 커밋링크를 달지말지 고민
<img src="https://github.com/5nTak/Unsplash_MVVMClean/assets/77046882/aca11eef-7aff-4910-9fac-f78207cfd9db" width="30%">

### PhotoDetailView Animation
- FullScreen으로 View가 띄워지며 이미지를 클릭하면 topInfoView가 숨겨지고 재클릭 시 다시 보여집니다.

- 이미지를 아래로 스와이프할 경우 DetailView를 빠져나와 이전 ListView로 돌아가는 PullDown Gesture를 구현했습니다.

<img src="https://github.com/5nTak/Unsplash_MVVMClean/assets/77046882/0a375826-fae7-4a04-a380-0a2b1d3b1ba0" width="30%">

- ListView로부터 선택된 사진만을 받아오는 것이 아닌 사진 목록 전체를 받아오고, 좌우 스크롤로 다음 사진을 볼 수 있도록 하기 위해 UICollectionView를 활용했습니다.

<img src="https://github.com/5nTak/Unsplash_MVVMClean/assets/77046882/a5ed5b99-86fe-4784-ba1f-0d8dde62bee6" width="30%">

- 현재 Index계산을 위해 collectionView의 contentOffset을 활용했습니다.
```swift
private var currentItemRow: Int {
        return Int(collectionView.contentOffset.x / collectionView.frame.size.width)
    }
```

### UnderLineTextField
- TextField를 Custom한 UnderLineTextField타입을 만들어 backgroundColor가 black인 View에서 TextField의 가시성을 보완했고, 빈 문자열을 전달 시 경고문구를 띄우고 유저가 바로 알 수 있도록 시각적인 효과를 줬습니다.
<img src="https://github.com/5nTak/Unsplash_MVVMClean/assets/77046882/ea7ed2f6-fe6f-457a-8ba2-47f18a101528" width="30%">

### CompositionalLayout
- 각 contents의 type에 따라 가로 스크롤, 세로 스크롤이 가능하게 하기 위해 CompositionalLayout을 활용했습니다.
<img src="https://github.com/5nTak/Unsplash_MVVMClean/assets/77046882/3e75eda6-9c7d-4723-9f4c-dbdaadb313d0" width="30%">

## SearchTab
### SearchView와 SearchResultView의 데이터 통신
- 문제점
    - `SearchViewController`를 생성할 때 매개변수로 `searchResultViewController`를 할당해야 합니다. 이 때 `SearchResultViewController()`라는 인스턴스를 할당해버리면 해당 인스턴스의 ViewModel과 **실제로 데이터 통신을 하는 ViewModel**이 매칭이 되지 않는 문제가 있었습니다.
- 해결법
    - 이를 해결하기 위해 `SearchViewModel`안에 `SearchResultViewController`를 반환하는 메서드를 만들어 `SearchViewController`에서 `searchResultViewController`를 할당할 때 호출했습니다.
```swift
// SearchViewController
private let viewModel = SearchViewModel()

let searchController = UISearchController(searchResultsController: viewModel.makeSearchResultViewController())

// SearchViewModel
private let searchResultViewModel = SearchResultViewModel()

func makeSearchResultViewController() -> SearchResultViewController {
    return SearchResultViewController(viewModel: searchResultViewModel)
}
```

### SearchResultViewModel에 데이터를 전달
- scopeButton이 select될 때마다 SearchResultViewModel에 `SearchType`을 전달하는 changeSearchType메서드가 호출되게 했습니다.
```swift
// SearchViewController
// UISearchBarDelegate
func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    var selectionType: SearchType = .photos
    switch selectedScope {
    case 1:
        selectionType = .collections
    case 2:
        selectionType = .users
    default:
        selectionType = .photos
    }
    
    viewModel.changeSearchType(searchType: selectionType)
    collectionView.setContentOffset(.zero, animated: true)
}

// SearchViewModel
func changeSearchType(searchType: SearchType) {
    searchResultViewModel.currentSearchType = searchType
}
```
## SearchResultView
- 현재 SearchType에 따라 다르게 네트워킹을 하는 `task`객체를 생성하고, scopeButton의 변화를 감지해 동작을 수행하기 위한 `currentSearchType`이라는 프로퍼티를 만들었습니다.
- scopeButton이 눌릴 때마다 currentSearchType이 바뀌고 currentSearchType이 바뀌면 items배열을 비우고 task를 cancel한 뒤, 네트워킹 메서드를 재호출하도록 했습니다.

<img src="https://github.com/5nTak/Unsplash_MVVMClean/assets/77046882/fc482719-7d1f-4ad6-a830-cb2185bde950" width="100%">

```swift
// SearchViewModel
func resetResult() {
        searchResultViewModel.resetResult()
    }
    
    func executeSearch(searchText: String) {
        searchResultViewModel.verifySearch(searchText: searchText)
        searchResultViewModel.prepareSearch()
    }

// SearchResultViewModel
var currentSearchType: SearchType = .photos {
    didSet {
      verifySearch()
      prepareSearch()
      searchHandler?(items)
      searchTypeHandler?(currentSearchType)
    }
}

func verifySearch(searchText: String = "") {
    resetResult()
    if !searchText.isEmpty {
        self.searchText = searchText
    }
    initialSearchState()
}

func initialSearchState() {
    task?.cancel()
    isSearchFetching = false
    pageNum = 0
    searchLastPageNum = -1
}

func prepareSearch() {
    if pageNum == searchLastPageNum {
        return
    }
    if isSearchFetching {
        return
    }
    isSearchFetching = true
    self.showItems()
}
```
