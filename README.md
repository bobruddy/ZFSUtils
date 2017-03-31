# ZFSUtils

These tools are designed for managing a ubuntu system that is
running off zfs as its rootFS

With zfs as your rootFS you can take a snapshot, clone it as
a recovery rootFS. With entries in grub to boot off the recovery
rootFS you will always be able to recover after a bad upgrade, etc.
