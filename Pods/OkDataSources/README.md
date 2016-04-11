# OkDataSources
Wrappers for iOS TableView and CollectionView DataSources to simply its api at a minimum.

## Setup
Add OkDataSources pod to the podfile

```swift
pod 'OkDataSources'
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
        showMockItems()
    }
    
    private func showMockItems() {
        var items = [Item]()
        for i in 0..<10 {
            items.append(Item(value: "Item \(i)"))
        }
        dataSource.items = items
        tableView.reloadData()
    }
    
}


```

Look that `OkTableViewDataSource<Item, TableViewCell>` needs a **object** and  a **tableViewCell** (which has to conform [OkViewCell](OkViewCell) protocol)

In the **Storyboard** that cell needs to have an identifier like this "\(CLASSNAME)Idenfitier" (Example: **TableViewCellReuseIdenfitier**)

If you want to receive feedback about items selection, you need to add an `OkTableViewDelegate` to your `ViewController` and also it needs to conform [OkViewCellDelegate](OkViewCellDelegate) protocol.  

```swift
class TableViewController: UIViewController, OkViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: OkTableViewDataSource<Item, TableViewCell>!
    var delegate: OkTableViewDelegate<OkTableViewDataSource<Item, TableViewCell>, TableViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkTableViewDataSource()
        delegate = OkTableViewDelegate(dataSource: dataSource, presenter: self)
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        showMockItems()
    }
    
    private func showMockItems() {
        var items = [Item]()
        for i in 0..<10 {
            items.append(Item(value: "Item \(i)"))
        }
        dataSource.items = items
        tableView.reloadData()
    }
    
    // MARK: - OkViewCellDelegate
    func onItemClick(item: Item, position: Int) {
        showAlertMessage("\(item.value) clicked")
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
        showMockItems()
    }
    
    private func showMockItems() {
        var items = [Item]()
        for i in 0..<10 {
            items.append(Item(value: "Item \(i)"))
        }
        dataSource.items = items
        collectionView.reloadData()
    }
    
}
```

Look that `OkCollectionViewDataSource<Item, CollectionViewCell>` needs a **object** and  a **collectionViewCell** (which has to conform [OkViewCell](OkViewCell) protocol)

In the **Storyboard** that cell needs to have an identifier like this "\(CLASSNAME)ReuseIdenfitier" (Example: **CollectionViewCellReuseIdentifier**)

If you want to receive feedback about items selection, you need to add an `OkCollectionViewDelegate` to your `ViewController` and also it needs to conform [OkViewCellDelegate](OkViewCellDelegate) protocol.  

```swift
class CollectionViewController: UIViewController, OkViewCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: OkCollectionViewDataSource<Item, CollectionViewCell>!
    var delegate: OkCollectionViewDelegate<OkCollectionViewDataSource<Item, CollectionViewCell>, CollectionViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = OkCollectionViewDataSource()
        delegate = OkCollectionViewDelegate(dataSource: dataSource, presenter: self)
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        showMockItems()
    }
    
    private func showMockItems() {
        var items = [Item]()
        for i in 0..<10 {
            items.append(Item(value: "Item \(i)"))
        }
        dataSource.items = items
        collectionView.reloadData()
    }
    
    // MARK: - OkViewCellDelegate
    func onItemClick(item: Item, position: Int) {
        showAlertMessage("\(item.value) clicked")
    }
    
}

```

##For more Customization

If you need a fully customization of  DataSource or Delegate (TableView, CollectionView) you can simply create a class that inherits from them and just override the methods that you need

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

##Credits
This approach is based in https://github.com/Karumi/BothamUI