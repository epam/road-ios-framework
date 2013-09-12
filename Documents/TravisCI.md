## How to Add New Project to Travis CI

1. Open up the **Manage Schemes** sheet by selecting the **Product** menu > **Scheme** > **Manage Schemes...**
2. Locate your application target in the list. Ensure that the **Shared** checkbox in far right hand column of the sheet is checked.
3. You will now have a new file in the **xcshareddata/xcschemes** directory underneath your Xcode project. This is the shared Scheme that you just configured. Check this file into your repository.
4. Add line of the next form to `.travis.yml`
`- xctool -workspace YourWorkspace.xcworkspace -scheme YourScheme build test -sdk iphonesimulator`