After struggling with this project for one day, finally did it. Commit some notifications here:

1. There is no need to put all `createXXXMO` methods in the `delegate.m` file. 
Although it is working as a centralized control, put those methods in other class files may reduce ambiguity.

2. Tedious and repetitive code can be improved in an elegant way.

3. The app reads data from CoreData storage frequently, which is inefficient when the database is large.

4. Adjust timezone and time format to make those more human-friendly.
