# Segmentation and Paging Framework
----
## Segmentation
```
1. Logical Address(Far Pointer):                   
==> Logical Address:               |    Segment Selector   |   + Offset | 
==> Global Descriptor Table(GDT)   |   +Segment Selector   |            |
==> Base: Segment Descriptor       |                       |   + Offset |    ==> Linear Address
```
----
## Paging
```
2. Linear Address Space
==> Linear Address :                 |    Dir |  + Table  |  + Offset | 
==> Base: Page Directory Table(PDT)  |  + Dir |           |           |   ==> PDE 
==> Base:Page Table(PT)              |        |  + Table  |           |   ==> PTE
==> Base:Physical Page Frame         |        |           |  + Offset |   ==> Physical Address
```
-----
