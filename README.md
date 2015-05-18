# IOSTrelloDemo
Dont forget to run pod install.<br>
The Application implements all features both the obligatory, aswell as the optional ones.<br>
On first run the app will show a login screen which is self explainatory.<br>
On the main view to dran&drop item you have to long press the item you want to interact with.<br>
In the upper right corner there is a button to enable/disable a lock that blocks the ability to add cards to other lists than the first one.<br>
Adding new cards id done by drag&drop from the left bottom corner there the card "source" is located.<br>
App works both online and offline and has pull to refresh added on each list.<br>
For aesthetics multiple animations have been added all throughout the app.
<p>
App is compliant to MVC, so the model layer is the only connection that a ViewController has with network services. After obtaining data controller uses Reactive Cocoa to react to data changes. DataManager thanks to JsonModel's internal implementation of encodeUsingCoder and initWithCoder can serialize and deserialize to NSUserDefaults and that is how persistancy of state for offline is done.<br>
As a networking solution AFNetworking is used and for parsing/inflating model objects i used JSONModel. Testing done with Specta/Expecta.<br>
All strings localized.
</p>
