module Tree
    exposing
        ( Tree
        , Zipper
        , Path
          -- Tree operations
        , empty
        , zipper
        , map
          -- Zipper operations
        , goToChild
        , goToRightMostChild
        , goUp
        , goLeft
        , goRight
        , goToRoot
        , goToNext
        , goToPrevious
        , goTo
        , updateFocusDatum
        , datum
        , insertChild
        , updateChildren
        , getPath
          -- Path operations
        , goToPath
        , updateDatum
        )

-- It will be a multiway Tree implementation, not a binary tree.
--


type Path
    = Path Id (List Int)


type alias Id =
    Int


type Tree
    = Tree
        { nextId : Id
        , nodeData : NodeArray a
        , innerTree : InnerTree
        }


type InnerTree
    = InnerTree
        { id : Id
        , children : Forest
        }


type alias Forest =
    List InnerTree


type Context
    = Context
        { id : Id -- Needed here?
        , focus : Focus -- At top-level in zipper or here?
        , pre : Forest
        , post : Forest
        }


type alias Breadcrumbs =
    List Context


type alias NodeArray a =
    Array Int a


type alias Focus =
    { nextId : Id
    , currentPath : Path
    }


type Zipper a
    = Zipper
        { nextId : Id -- In the focus or here?
        , nodeData : NodeArray a
        , innerTree : InnerTree
        , crumbs : Breadcrumbs
        }



-- Tree operations
--, empty
--, zipper
--, map
--
-- Zipper operations
-- , goToChild
-- , goToRightMostChild
-- , goUp
-- , goLeft
-- , goRight


{-| The Tree will only be able to be manipulated through TreeExplorer or Zipper.
The Tree implementation data structure will not be exposed; it will be opaque.
This is so that all work on the Tree can carry around a Focus context;
in particular, a current id stamp used to label all nodes with unique references.
Ataching and removing this Focus context will happen within the implementation
and not something that the caller has to remember and pass around.

Walking the zipper context back to the root will produce a Tree and a Path.
If just the Path is needed, that can be extracted efficiently, without walking
back to the root, by the `getPath` function.

-}
goToRoot : Zipper a -> ( Tree a, Path )



-- , goToNext
-- , goToPrevious
-- , goTo
-- , updateFocusDatum
-- , datum
-- , insertChild
-- , updateChildren
-- , getPath
--
-- Path operations


{-| The Path and Tree can be recombined to recover a previous position in the tree.
walkPath : Path -> Tree a -> Maybe (Zipper a)

Every node will be marked with a unique id, so that re-walking the tree from a Path
can be confirmed as correct. Walking a Path will produce a Maybe.

This allows events to be tagged with Paths which describe a return to a
previously visited position within a tree, without capturing any other data
associated with that node. This is to circumvent the stale data issue when
a user is interacting with a tree.

-}
goToPath : Path -> Tree a -> Maybe (Zipper a)


{-| The contents of nodes in the tree will be held in an `Array Id a`. Ids will be assigned
sequentially. This will allow mapping by id without re-walking a Path possible. It will
only be necessary to re-walk paths when adding new nodes into the tree, as this is the only
situation when fresh ids will need to be generated.
-}
updateDatum : Path -> (a -> a) -> Tree a -> Tree a
