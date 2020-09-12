# Segmentation and Paging Framework
----
## Segmentation
```
1. Logical Address(Far Pointer): Segment Selector            + Offset
==> Global Descriptor Table(GDT)                             + Segment Selector
        ==> Segment Descriptor (Segment Base Address)        + Offset
                ==> Linear Address
```
----
## Paging
```
2. Linear Address Space
==> Linear Address : Dir                       + Table                 + Offset
        ==> Page Directory Table(PDT)          + Dir 
                ==> Entry(PDE)
                ==> Page Table(PT)             + PDE   
                        ==> Entry(PTE)
                        ==> PTE                                        + Offset
                                ==> Physical Address(Page)
```
-----
