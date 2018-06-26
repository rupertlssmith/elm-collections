module Tree exposing (..)

-- It will be a multiway Tree implementation, not a binary tree.
--


type Path
    = List Int


type Tree a
    = Tree a (Forest a)


type alias Forest a =
    List (Tree a)


type Context a
    = Context a (Forest a) (Forest a)


type alias Breadcrumbs a =
    List (Context a)


type alias Zipper a =
    ( Tree a, Breadcrumbs a )


type alias Focus =
    { currentId : Int
    }



-- Every node will be marked with a unique id, so that re-walking the tree from a Path
-- can be confirmed as correct. Walking a Path will produce a Maybe.


walkPath : Path -> Tree a -> Maybe (Zipper a)



--
-- The Tree will only be able to be manipulated through TreeExplorer or Zipper.
-- The Tree implementation data structure will not be exposed; it will be opaque.
-- This is so that all work on the Tree can carry around a Focus context;
-- in particular, a current id stamp used to label all nodes with unique references.
-- Ataching and removing this Focus context will happen within the implementation
-- and not something that the caller has to remember and pass around.
--
-- Walking the zipper context back to the root will produce a Tree and a Path.


walkToRoot : Zipper a -> ( Tree a, Path )



--
-- The Path and Tree can be recombined to recover a previous position in the tree.
-- walkPath : Path -> Tree a -> Maybe (Zipper a)
--
-- This allows events to be tagged with Paths which describe a return to a
-- previously visited position within a tree, without capturing any other data
-- associated with that node. This is to circumvent the stale data issue when
-- a user is interacting with a tree.
--
-- The contents of nodes in the tree will be held in an `Array Id a`. Ids will be assigned
-- sequentially. This will allow mapping by id without re-walking a Path possible. It will
-- only be necessary to re-walk paths when adding new nodes into the tree, as this is the only
-- situation when fresh ids will need to be generated.


mapNode : Path -> (a -> a) -> Tree a -> Tree a



--
-- This more complex scheme may allow a more efficient return to a single position
-- within a Tree than using `indexedMap`. This should be tested; for example could
-- a tree with hundreds of visible nodes have many of them animated in parallel
-- or would there be too much garbage collection churn when running this data structure?
-- type alias Path =
--     List Int
--
--
-- type Tree a
--     = Tree a (Forest a)
--
--
-- type alias Forest a =
--     List (Tree a)
--
--
-- type TreeExplorer a
--     = Branch (Forest a) TreeExplorer (Forest a)
--     | Focus Whatever Tree Tree
--
--
-- type alias Focus =
--     { currentId : Int
--     }
