fix/codex-pages
===============

.. dfhack-tool::
    :summary: Add pages to written content that have no pages.
    :tags: fort bugfix items

Add pages to codices, quires, and scrolls that do not have specified page counts.

Usage
-----

``fix/codex-pages [this|site|all]``

This tool will add pages to written works that do not have their start and end
pages specified. The number of pages to be added will be determined mainly by
the type of the written content, modified by its writing style and the strength
of the style, with weighted randomization.

Options
-------

``this``
    Add pages to the selected codex, quire, or scroll item.

``site``
    Add pages to all written works that are currently in the player's fortress.

``all``
    Add pages to all written works to have ever existed in the world.

Note
----

Quires and scrolls will never display the number of pages they contain even if
their page count is specified in the data structure of their written content.
Once a quire is binded into a codex, the number of pages it contains will be
displayed in its item description.
