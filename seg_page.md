# Segmentation and Paging Framework
----
## Segmentation
```
1. Logical Addres(Far Pointer):    |       16 bits         |   32 bits  |          
==> Logical Address:               |    Segment Selector   |   + Offset | 
==> Global Descriptor Table(GDT)   |   +Segment Selector   |            |
==> Base: Segment Descriptor       |                       |   + Offset | ==> Linear Address
```
----
## Paging
```
2. Linear Address Space              | 10 bits|   10 bits |  12bits   |
==> Linear Address :                 |    Dir |  + Table  |  + Offset | 
==> Base: Page Directory Table(PDT)  |  + Dir |           |           |   ==> PDE 
==> Base:Page Table(PT)              |        |  + Table  |           |   ==> PTE
==> Base:Physical Page Frame         |        |           |  + Offset |   ==> Physical Address
```
-----
