 

Base App iOS
================

Base skeleton structure to start every new project, based on the design patters suggested by Robert C. Martin *(aka Uncle Bob)* on his clean architecture.

*base_app_ios* is the project which we use at [Refineria Web](http://www.refineriaweb.com/servicios/desarrollo-apps-moviles/) to start any new iOS project. It presents a structure of 3 layers, domain, data and presentation; this approach has been chosen with the purpose of creating an application that conducts unit testing and also allow the portability between platforms, mainly Android.

The project is divided in three modules:
* **domain**: Dependencies: swinject, rxswift.
* **data**: It’s the repository that supplies the data which will be consumed by the domain module. Dependencies: domain module, moya, swinject, objectmapper, rxswift, rxcache.
* **presentation**: It links the two previous modules and implement all the views interfaces defined in domain module. Dependencies: domain and data module, swinject, rxswift.

The application implements a minimal example using the Github Api. It's purpose is to illustrate in a simple way the natural workflow derived from this kind of architecture, using the classes created in the foundation packages in every one of the 3 layers. 

To facility the use of this project as a common base one for any new project, a ruby script called *start_fresh* has been created. This task removes the earlier mentioned minimal example, leaving the appliaction in an optimal state to start any new project (Still need to remove manually missing referencies after running this script). 

Just run the next command from any terminal located at the root project:

```ruby
ruby start_fresh.rb
```
After that, remove missing referencies (directories, files), build and clean project
