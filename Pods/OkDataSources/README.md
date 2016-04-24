# OkDataSources
Wrappers for iOS TableView and CollectionView DataSources to simply its api at a minimum.

## Setup
Add OkDataSources pod to the podfile

```swift
pod 'OkDataSources'
```

For RxSwift extension, this project will include it as a dependency.  So you can do this via CocoaPods subspecs.

```swift
pod 'OkDataSources'
pod 'OkDataSources/RxSwift'
```

## Usage

OkDataSources provides several dataSources and delegates to deal with iOS TableViews and CollectionViews

## TableViews
```swift
class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: OkTableViewDataSource<Item, TableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkTableViewDataSource()
        tableView.dataSource = dataSource
    }
    
}

```

Look that `OkTableViewDataSource<Item, TableViewCell>` needs an object and a `tableViewCell` (which has to conform [OkViewCell](https://github.com/FuckBoilerplate/OkDataSources/blob/master/Library/OkViewCell.swift) protocol)

```swift
class TableViewCell: UITableViewCell, OkViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    func configureItem(item: Item) {
        valueLabel.text = item.value
    }
}
```

In the **Storyboard** the cell needs to have an identifier like this **"\\(CLASSNAME)Idenfitier"** (For instance: **TableViewCellReuseIdenfitier**)

![TableViewCell - 1](http://i.imgur.com/SAj4XMP.png)
![TableViewCell - 2](http://i.imgur.com/HNfk3GT.png)

If you want to receive feedback about items selection, you need to add an `OkTableViewDelegate` to your `ViewController`, so `onItemClicked` block its going to be called every time the user clicks an item.

```swift
class TableViewController: UIViewController, OkViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: OkTableViewDataSource<Item, TableViewCell>!
    var delegate: OkTableViewDelegate<OkTableViewDataSource<Item, TableViewCell>, TableViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkTableViewDataSource()
        delegate = OkTableViewDelegate(dataSource: dataSource,
            onItemClicked: { (item, position) in
            self.showAlertMessage("\(item.value) clicked")
        })
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }

}
```

## CollectionView

```swift
class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: OkCollectionViewDataSource<Item, CollectionViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkCollectionViewDataSource()
        collectionView.dataSource = dataSource
    }
    
}
```

Look that `OkCollectionViewDataSource<Item, CollectionViewCell>` needs an object and  a `collectionViewCell` (which has to conform [OkViewCell](https://github.com/FuckBoilerplate/OkDataSources/blob/master/Library/OkViewCell.swift) protocol)

```swift
class CollectionViewCell: UICollectionViewCell, OkViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    func configureItem(item: Item) {
        valueLabel.text = item.value
    }
}
```

In the **Storyboard** the cells needs to have an identifier like this **"\\(CLASSNAME)ReuseIdenfitier"** (For instance: **CollectionViewCellReuseIdentifier**)

![CollectionViewCell - 1](http://i.imgur.com/BatGgD8.png)
![CollectionViewCell - 2](http://i.imgur.com/pYtw3Jr.png)

If you want to receive feedback about items selection, you need to add an `OkCollectionViewDelegate` to your `ViewController`, so `onItemClicked` block its going to be called every time the user clicks an item.

```swift
class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: OkCollectionViewDataSource<Item, CollectionViewCell>!
    var delegate: OkCollectionViewDelegate<OkCollectionViewDataSource<Item, CollectionViewCell>, CollectionViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkCollectionViewDataSource()
        delegate = OkCollectionViewDelegate(dataSource: dataSource,
            onItemClicked: { (item, position) in
                self.showAlertMessage("\(item.value) clicked")
        })
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
    }
       
}

```

##Also they have PullToRefresh and Pagination functionalities in their OkDelegates

### PullToRefresh

Using tableViews

```swift
delegate.setOnPullToRefresh(tableView) { (refreshControl) -> Void in
            print("refreshed")    
            // You need to stop the UIRefreshControl manually when you want to
            refreshControl.endRefreshing()
        }
```

Using collectionViews

```swift
delegate.setOnPullToRefresh(collectionView) { (refreshControl) -> Void in
            print("refreshed")   
             // You need to stop the UIRefreshControl manually when you want to
            refreshControl.endRefreshing()
        }
```

### Pagination

For tableViews and collectionViews

```swift
delegate.setOnPagination { (item) -> Void in
           // Ask for more items
        }
```

##For more Customization

If you need a fully customization of `DataSource` or `Delegate` (`TableView`, `CollectionView`) you can simply create a class that inherits from them and just override the methods that you need

```swift
class ExampleTableViewDataSource: OkTableViewDataSource<Item, TableViewCell> {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = itemAtIndexPath(indexPath)

        var cell: TableViewCell!

        // Some condition        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("Some Custom Identifier 1", forIndexPath: indexPath) as! TableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("Some Custom Identifier 2", forIndexPath: indexPath) as! TableViewCell
        }
        cell.configureItem(item)
    return cell
}
```

##RxSwift

There are 2 delegates OkRxTableViewDelegate and OkRxCollectionViewDelegate, use them instead of the regular ones

RxSwift provides extra flavor to the Pagination and PullToRequest functionalities

TableView
``` swift
delegate = OkRxTableViewDelegate(dataSource: dataSource,
            onItemClicked: { (item, position) in
                self.showAlertMessage("\(item.value) clicked")
        })
        delegate.setOnPullToRefresh(tableView) {
            return Observable.just(self.getMockItems())
        }
        delegate.setOnPagination { (item) -> Observable<[Item]> in
            return Observable.just(self.getMockItems(self.dataSource.items.count))
        }
```

CollectionView
```swift
delegate = OkRxCollectionViewDelegate(dataSource: dataSource,
            onItemClicked: { (item, position) in
                self.showAlertMessage("\(item.value) clicked")
        })
        delegate.setOnPullToRefresh(collectionView) {
            return Observable.just(self.getMockItems())
        }
        delegate.setOnPagination { (item) -> Observable<[Item]> in
            return Observable.just(self.getMockItems(self.dataSource.items.count))
        }   
```
##Credits
This approach is based on https://github.com/Karumi/BothamUI
