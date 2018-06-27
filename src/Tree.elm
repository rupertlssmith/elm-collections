module Tree
    exposing
        ( Tree
        , Zipper
        , Path
          -- Tree operations
        , singleton
        , zipper
        , map
          -- Zipper operations
          --, goToChild
          --, goToRightMostChild
        , goUp
          --, goLeft
          --, goRight
        , goToRoot
          --, goToNext
          --, goToPrevious
          --, goTo
          --, updateFocusDatum
          --, datum
          --, insertChild
          --, updateChildren
          --, getPath
          -- Path operations
          --, goToPath
          --, updateDatum
        )

-- It will be a multiway Tree implementation, not a binary tree.
--
-- Will save this for an optimized version:
-- type alias NodeArray a =
--     Array Int a


type alias Id =
    Int


type Tree a
    = Tree
        { nextId : Id
        , innerTree : InnerTree a
        }


type Zipper a
    = Zipper
        { nextId : Id
        , currentPath : Path
        , innerTree : InnerTree a
        , crumbs : Breadcrumbs a
        }


type Path
    = Path Id (List Int)


type InnerTree a
    = InnerTree
        { id : Id
        , datum : a
        , children : Forest a
        }


type alias Forest a =
    List (InnerTree a)


type Context a
    = Context
        { id : Id
        , datum : a
        , before : Forest a
        , after : Forest a
        }


type alias Breadcrumbs a =
    List (Context a)



-- Id operations


getNextId : Id -> Id
getNextId id =
    id + 1



-- Tree operations


singleton : a -> Tree a
singleton datum =
    Tree
        { nextId = 0
        , innerTree =
            InnerTree
                { id = 0
                , datum = datum
                , children = []
                }
        }


zipper : Tree a -> Zipper a
zipper (Tree tree) =
    Zipper
        { nextId = tree.nextId
        , currentPath =
            case tree.innerTree of
                InnerTree inner ->
                    Path inner.id []
        , innerTree = tree.innerTree
        , crumbs = []
        }


mapInner : (a -> b) -> InnerTree a -> InnerTree b
mapInner fn (InnerTree tree) =
    let
        mappedDatum =
            fn tree.datum

        mappedChildren =
            List.map (\child -> mapInner fn child) tree.children
    in
        (InnerTree
            { id = tree.id
            , datum = mappedDatum
            , children = mappedChildren
            }
        )


map : (a -> b) -> Tree a -> Tree b
map fn (Tree tree) =
    let
        mappedInner =
            mapInner fn tree.innerTree
    in
        (Tree
            { nextId = tree.nextId
            , innerTree = mappedInner
            }
        )


{-| This operation may be faster than `map` when the type of the tree does not change.
It should be preferred to `map` in that case.
-}
update : (a -> a) -> Tree a -> Tree a
update fn tree =
    map fn tree



-- Zipper operations


{-| Walking the zipper context back to the root will produce a Tree with any
updates made as the zipper was walked over the tree, folded back in to the
new Tree.
-}
goToRoot : Zipper a -> Zipper a
goToRoot (Zipper zipper) =
    case zipper.crumbs of
        [] ->
            Zipper zipper

        otherwise ->
            goUp (Zipper zipper)
                |> Maybe.map goToRoot
                |> Maybe.withDefault (Zipper zipper)



-- goToChild : Int -> Zipper a -> Maybe (Zipper a)


goUp : Zipper a -> Maybe (Zipper a)
goUp (Zipper zipper) =
    case zipper.crumbs of
        (Context { id, datum, before, after }) :: bs ->
            Just
                (Zipper
                    { nextId = zipper.nextId
                    , currentPath =
                        case zipper.currentPath of
                            Path _ [] ->
                                Path id []

                            Path _ (_ :: ps) ->
                                Path id ps
                    , innerTree =
                        InnerTree
                            { id = 0
                            , datum = datum
                            , children = (before ++ [ zipper.innerTree ] ++ after)
                            }
                    , crumbs = bs
                    }
                )

        [] ->
            Nothing


goLeft : Zipper a -> Maybe (Zipper a)
goLeft (Zipper zipper) =
    case zipper.crumbs of
        (Context { id, datum, before, after }) :: bs ->
            case List.reverse before of
                [] ->
                    Nothing

                (InnerTree inner) :: rest ->
                    Nothing

        [] ->
            Nothing


goRight : Zipper a -> Maybe (Zipper a)
goRight (Zipper zipper) =
    case zipper.crumbs of
        (Context { id, datum, before, after }) :: bs ->
            case after of
                [] ->
                    Nothing

                (InnerTree inner) :: rest ->
                    Nothing

        [] ->
            Nothing



-- goToNext : Zipper a -> Maybe (Zipper a)
-- goToPrevious : Zipper a -> Maybe (Zipper a)
-- goToRightMostChild : Zipper a -> Maybe (Zipper a)
-- goTo : (a -> Bool) -> Zipper a -> Maybe (Zipper a)
-- datum : Zipper a -> a
-- updateFocusDatum : (a -> a) -> Zipper a -> Zipper a
-- insertChild : a -> Zipper a -> Zipper a
-- appendChild : a -> Zipper a -> Zipper a
-- getPath : Zipper a -> Path
-- Path operations
{- The Path and Tree can be recombined to recover a previous position in the tree.
   walkPath : Path -> Tree a -> Maybe (Zipper a)

   Every node will be marked with a unique id, so that re-walking the tree from a Path
   can be confirmed as correct. Walking a Path will produce a Maybe.

   This allows events to be tagged with Paths which describe a return to a
   previously visited position within a tree, without capturing any other data
   associated with that node. This is to circumvent the stale data issue when
   a user is interacting with a tree.

-}
-- goToPath : Path -> Tree a -> Maybe (Zipper a)
{- The contents of nodes in the tree will be held in an `Array Id a`. Ids will be assigned
   sequentially. This will allow mapping by id without re-walking a Path possible. It will
   only be necessary to re-walk paths when adding new nodes into the tree, as this is the only
   situation when fresh ids will need to be generated.
-}
-- updateDatum : Path -> (a -> a) -> Tree a -> Tree a
