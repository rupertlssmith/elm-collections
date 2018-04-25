# elm-collections

elm-collections is a data structure library for Elm, inspired by Java Collections.

In Java all objects can define `equals` and `hashCode` methods, and can additionally
supply methods that supply partial ordering relations over objects of a particular
class too. The Collections library makes use of these features to provide a rich set
of data structures over objects.

In Elm, we define as extensible records type classes for equality and ordering:

    type alias Equality a =
        { a
            | equals : Equality a -> Equality a -> Bool
            , hashCode : Equality a -> Int
        }


    type alias Ordering a =
        { a
            | order : Ordering a -> Ordering a -> Order
        }

and let the user implement this API to provide the same set of features as above
for this collections library to be based on.

Elm already provides a polymorphic `==` operator, that compares records by value.
It is sometimes desirable for a record to only use a sub-set of its fields for
an equality check, such as an `id` field. A hash code is a potential short cut to
checking equality, and must always be given when customizing equality checks.
