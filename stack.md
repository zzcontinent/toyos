# stack usage when function called
----

```
 +----------------+
+|  stack botom   | <- 高位地址  
 +----------------+
 |    ...         |
 +----------------+
 |    ...         |
 +----------------+
 |   param3       |
 +----------------+
 |   param2       |
 +----------------+
 |   param1       |
 +----------------+
 | retrun address | 
 +----------------+
 | previous [ebp] | <- [ebp]
 +----------------+
-| local variables| <- 低位地址 <- [esp]
 +----------------+
```

# stack usage with no privillege-level changed
----

```
interrupted procedure's and handler's stack
+-------------------+
|                   | <- ESP before transfer to handler 
+-------------------+
|      EFLAGES      | 
+-------------------+
|        CS         |
+-------------------+
|        EIP        |
+-------------------+
|   Error Code      | <- ESP after transfer to handler
+-------------------+
|                   |
+-------------------+

```

# stack usage with no privillege-level changed
----

```
interrupted procedure's stack                                                 handler's stack
+-------------------+                                                       +-------------------+
|                   | <- ESP before transfer to handler                     |                   |
+-------------------+                                                       +-------------------+
|                   |                                                       |         SS        |
+-------------------+                                                       +-------------------+
|                   |                                                       |         ESP       |
+-------------------+                                                       +-------------------+
|                   |                                                       |      EFLAGES      |
+-------------------+                                                       +-------------------+
|                   |                                                       |        CS         |
+-------------------+                                                       +-------------------+
|                   |                                                       |        EIP        |
+-------------------+                                                       +-------------------+
|                   |                     ESP after transfer to handler ->  |   Error Code      |
+-------------------+                                                       +-------------------+
|                   |                                                       |                   |
+-------------------+                                                       +-------------------+
```


