fix/archery-practice
====================

.. dfhack-tool::
    :summary: Consolidate and remove extra ammo items to fix 'Soldier (no item)' issue.
    :tags: fort bugfix items

Combine ammo items inside quivers that are assigned for training to allow
archery practice to take place.

Usage
-----

``fix/archery-practice``
    Combine ammo items inside quivers that are assigned for training.

``fix/archery-practice -q``, ``fix/archery-practice --quiet``
    Combine ammo items inside quivers that are assigned for training.
    Do not print to console.

This tool will combine ammo items inside the quivers of units in squads
that are currently set to train with the objective of ensuring that each
unit hold only one combined stack of ammo item assigned for training in
their quiver. Any ammo items left over after the combining operation
will be dropped on the ground.

The 'Soldier (no item)' issue
-----------------------------

Due to a bug in the game, a unit that is scheduled to train will not be
able to practice archery at the archery range when their quiver contains
more than one stack of ammo item that is assigned to them for training.
This is indicated on the unit by the 'Soldier (no item)' status.

The issue occurs when the game assigns an ammo item with a stack size of
less than 25 to the unit, prompting the game to assign additional stacks
of ammo items to make up for the deficit.

The workaround to this issue is to ensure the squad ammo assignments
for use in training contain as few ammo items with stack sizes smaller
than 25 as possible. Since training bolts are often made from wood or
bone which are created in stacks of 5, the use of the  ``combine`` tool on
ammo stockpiles is recommended to reduce the frequency of this issue
occurring, while "incomplete" stacks of ammo items that are already
picked up by training units can be managed by this tool.

Any other stacks of ammo items inside the quiver that are not assigned
for training will not affect the unit's ability to practice archery.

As of DF version 52.05, this bug should already be fixed.

Limitations
-----------

Due to the very limited number of ammo items a unit's quiver might contain,
the material, quality, and maker of the items are ignored when performing
the combining operation on them. Only ammo items assigned for training will
be combined, while ammo items inside the quiver that are assigned for combat
will not be affected.

Although this tool will consolidate ammo items inside quivers and discard
any surplus items, the training units may not immediately go for archery
practice, especially if they are still trying to collect more ammo items
that the game have assigned to them.
